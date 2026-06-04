local M = {}

local registered = false
local title_prefix = "(Bitwarden"
local title_suffix = "Password Manager) - Bitwarden"
local popup_width = 420
local popup_height = 520
local pending_timers = {}
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

local function window_address(window)
  if window == nil or window.address == nil then
    return nil
  end

  local address = tostring(window.address)
  address = address:match("^%s*(.-)%s*$")
  address = address:gsub("^0[xX]", "")

  if address:match("^[%x]+$") then
    return "0x" .. address
  end

  return nil
end

local function target_size(window)
  return popup_width, popup_height
end

local function is_bitwarden_password_manager(title)
  if type(title) ~= "string" then
    return false
  end

  local prefix_at = title:find(title_prefix, 1, true)
  local suffix_at = title:find(title_suffix, 1, true)

  return prefix_at ~= nil and suffix_at ~= nil and prefix_at < suffix_at
end

local function apply_fix(selector, width, height)
  log("applying " .. selector .. " size=" .. width .. "x" .. height)
  hl.dispatch(hl.dsp.window.float({ action = "set", window = selector }))
  hl.dispatch(hl.dsp.window.resize({ x = width, y = height, window = selector }))
  hl.dispatch(hl.dsp.window.center({ window = selector }))
end

local function schedule_fix(selector, width, height)
  local timer

  timer = hl.timer(function()
    pending_timers[timer] = nil
    apply_fix(selector, width, height)
  end, { timeout = 100, type = "oneshot" })

  pending_timers[timer] = true
end

local function fix_window(window)
  local address = window_address(window)
  if not address then
    log("fix skipped: missing address")
    return
  end

  local width, height = target_size(window)
  if not width then
    log("fix skipped: missing monitor for " .. address)
    return
  end

  local selector = "address:" .. address
  log("scheduling " .. selector .. " title=" .. tostring(window.title) .. " size=" .. width .. "x" .. height)
  schedule_fix(selector, width, height)
end

local function fix_matching_windows()
  log("sweeping existing windows")
  for _, window in ipairs(hl.get_windows()) do
    if is_bitwarden_password_manager(window.title) then
      fix_window(window)
    end
  end
end

function M.setup()
  if registered then
    return
  end

  registered = true
  log("setup")

  hl.window_rule({
    name = "Bitwarden browser extension popup",
    float = true,
    size = popup_width .. " " .. popup_height,
    center = true,
    match = {
      class = "^(zen|firefox)$",
      title = [[.*\(Bitwarden Password Manager\) - Bitwarden.*]],
    },
  })

  hl.on("window.open", function(window)
    if window ~= nil and (window.class == "zen" or window.class == "firefox") then
      log("window.open class=" .. tostring(window.class) .. " title=" .. tostring(window.title))
    end

    if window ~= nil and is_bitwarden_password_manager(window.title) then
      fix_window(window)
    end
  end)

  hl.on("window.title", function(window)
    if window ~= nil and (window.class == "zen" or window.class == "firefox") then
      log("window.title class=" .. tostring(window.class) .. " title=" .. tostring(window.title))
    end

    if window ~= nil and is_bitwarden_password_manager(window.title) then
      fix_window(window)
    end
  end)

  hl.on("config.reloaded", fix_matching_windows)
  fix_matching_windows()
end

M.is_bitwarden_password_manager = is_bitwarden_password_manager
M.fix_window = fix_window

return M
