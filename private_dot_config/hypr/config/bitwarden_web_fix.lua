local M = {}

local registered = false
local title_fragment = "(Bitwarden Password Manager) - Bitwarden"
local firefox_startup_title = "Mozilla Firefox"
local popup_width = 420
local popup_height = 520
local pending_firefox = {}
local fixed_windows = {}
local debug = false
local log_path = "/tmp/bitwarden_web_fix.log"

local function log(message)
  if not debug then
    return
  end

  local file = io.open(log_path, "a")
  if file then
    file:write(os.date("%Y-%m-%d %H:%M:%S "), message, "\n")
    file:close()
  end
end

local function is_bitwarden_password_manager(title)
  return type(title) == "string" and title:find(title_fragment, 1, true) ~= nil
end

local function is_bitwarden_window(window)
  if window == nil then
    return false
  end

  -- Chromium assigns extension popups their own class, including the profile name.
  return (type(window.class) == "string"
      and window.class:match("^chrome%-nngceckbapebfimnlniiiahkandclblb%-.+$") ~= nil)
    or (window.class == "firefox" and is_bitwarden_password_manager(window.title))
end

local function apply_fix(window)
  log("applying " .. tostring(window) .. " size=" .. popup_width .. "x" .. popup_height)
  hl.dispatch(hl.dsp.window.float({ action = "enable", window = window }))
  hl.dispatch(hl.dsp.window.resize({ x = popup_width, y = popup_height, window = window }))
  hl.dispatch(hl.dsp.window.center({ window = window }))
end

local function fix_window(window)
  if window == nil or not window.mapped or not is_bitwarden_window(window) then
    return
  end

  local window_id = window.stable_id
  if window_id == nil or fixed_windows[window_id] then
    return
  end

  apply_fix(window)
  fixed_windows[window_id] = true
end

local function is_firefox_loading_title(title)
  return title == "" or title == firefox_startup_title or title == "about:blank"
    or (type(title) == "string" and title:match("^about:.*Mozilla Firefox$") ~= nil)
end

local function finish_firefox_startup(window, force)
  local window_id = window and window.stable_id
  if window_id == nil or not pending_firefox[window_id] then
    return
  end

  if window.mapped and window.class == "firefox" then
    if is_bitwarden_window(window) then
      fix_window(window)
    elseif not force and is_firefox_loading_title(window.title) then
      return
    else
      -- Ordinary Firefox windows go back to the tiled layout once identified.
      hl.dispatch(hl.dsp.window.float({ action = "disable", window = window }))
    end
  end

  pending_firefox[window_id] = nil
end

local function begin_firefox_startup(window)
  if window == nil or not window.mapped or window.class ~= "firefox"
      or window.initial_title ~= firefox_startup_title then
    return
  end

  local window_id = window.stable_id
  if window_id == nil or pending_firefox[window_id] or fixed_windows[window_id] then
    return
  end

  local state = {}
  pending_firefox[window_id] = state
  state.timer = hl.timer(function()
    -- A close/remap may have replaced this startup state.
    if pending_firefox[window_id] == state then
      finish_firefox_startup(window, true)
    end
  end, { timeout = 500, type = "oneshot" })
end

local function fix_matching_windows()
  log("sweeping existing windows")
  for _, window in ipairs(hl.get_windows()) do
    if is_bitwarden_window(window) then
      fix_window(window)
    elseif window.class == "firefox" and is_firefox_loading_title(window.title) then
      begin_firefox_startup(window)
    end
  end
end

function M.setup()
  if registered then
    return
  end

  registered = true
  log("setup")

  -- Firefox maps extension popouts with a generic title before naming them.
  -- Place that startup window before layout insertion to avoid a tiled flash.
  hl.window_rule({
    name = "Firefox startup for Bitwarden detection",
    float = true,
    size = popup_width .. " " .. popup_height,
    center = true,
    no_anim = true,
    match = {
      class = "^firefox$",
      title = "^Mozilla Firefox$",
    },
  })

  hl.window_rule({
    name = "Bitwarden browser extension popup",
    float = true,
    size = popup_width .. " " .. popup_height,
    center = true,
    no_anim = true,
    match = {
      class = "^firefox$",
      title = [[.*\(Bitwarden Password Manager\) - Bitwarden.*]],
    },
  })

  hl.window_rule({
    name = "Bitwarden Chromium extension popup",
    float = true,
    size = popup_width .. " " .. popup_height,
    center = true,
    match = {
      class = "^chrome-nngceckbapebfimnlniiiahkandclblb-.+$",
    },
  })

  hl.on("window.open_early", begin_firefox_startup)

  hl.on("window.open", function(window)
    if window ~= nil and window.class == "firefox" then
      log("window.open class=" .. tostring(window.class) .. " title=" .. tostring(window.title))
    end

    begin_firefox_startup(window)
    finish_firefox_startup(window, false)
    if is_bitwarden_window(window) then
      fix_window(window)
    end
  end)

  hl.on("window.title", function(window)
    if window ~= nil and window.class == "firefox" then
      log("window.title class=" .. tostring(window.class) .. " title=" .. tostring(window.title))
    end

    finish_firefox_startup(window, false)
    if is_bitwarden_window(window) then
      fix_window(window)
    end
  end)

  hl.on("window.close", function(window)
    local window_id = window and window.stable_id
    if window_id then
      -- Let invalidated oneshot timers expire so Hyprland releases their callbacks.
      pending_firefox[window_id] = nil
      fixed_windows[window_id] = nil
    end
  end)

  hl.on("config.reloaded", fix_matching_windows)
  fix_matching_windows()
end

M.is_bitwarden_password_manager = is_bitwarden_password_manager
M.fix_window = fix_window

return M
