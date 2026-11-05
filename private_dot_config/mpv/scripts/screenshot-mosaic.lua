local mp = require("mp")
local utils = require("mp.utils")
local options = require("mp.options")

local opts = {
    ffmpeg_path = "ffmpeg",
    columns = 4,
    rows = 4,
    resize = false,
    thumb_width = 320,
    thumb_height = 180,
    hdr_tonemap = "auto",
    hdr_tonemap_algorithm = "hable",
    hdr_tonemap_peak = 1000,
    hdr_tonemap_desat = 0,
    hdr_tonemap_npl = 100,
    darkmode = false,
    margin = 10,
    padding = 4,
    timestamp = true,
    timestamp_font = "",
    timestamp_font_size = 16,
    metadata = true,
    metadata_title = "mpv",
    metadata_title_font = "",
    metadata_title_font_size = 0,
    metadata_title_gap = 10,
    metadata_font = "",
    metadata_font_size = 0,
    metadata_header_height = 120,
    metadata_line_spacing = 2,
    metadata_bottom_padding = 12,
    output_directory = "",
    open_after_create = false,
}

options.read_options(opts, "screenshot-mosaic")

local function expand_path(path)
    if not path or path == "" then
        return path
    end

    if path == "~" then
        return os.getenv("HOME") or path
    end

    if path:sub(1, 2) == "~/" then
        local home = os.getenv("HOME")
        if home then
            return utils.join_path(home, path:sub(3))
        end
    end

    return path
end

local function file_exists(path)
    local f = io.open(path, "rb")
    if f then
        f:close()
        return true
    end
    return false
end

local function sanitize_filename(name)
    name = name:gsub("[/\\:*?\"<>|]", "_")
    name = name:gsub("%s+", " ")
    name = name:gsub("^%s+", ""):gsub("%s+$", "")
    if name == "" then
        return "mosaic"
    end
    return name
end

local function split_path(path)
    local dir, filename = utils.split_path(path)
    if not dir or dir == "" then
        dir = "."
    end
    return dir, filename
end

local function make_absolute_path(path)
    if not path or path == "" or path:sub(1, 1) == "/" then
        return path
    end

    local working_dir = mp.get_property("working-directory", "")
    if working_dir == "" then
        return path
    end

    return utils.join_path(working_dir, path)
end

local function output_path(source_path)
    local dir, filename = split_path(source_path)
    local configured_dir = expand_path(opts.output_directory)
    local screenshot_dir = expand_path(mp.get_property("screenshot-directory", ""))

    if configured_dir and configured_dir ~= "" then
        dir = configured_dir
    elseif screenshot_dir and screenshot_dir ~= "" then
        dir = screenshot_dir
    end

    local stem = sanitize_filename(filename:gsub("%.[^.]*$", ""))
    local candidate = utils.join_path(dir, stem .. "_mosaic.jpg")
    local i = 2

    while file_exists(candidate) do
        candidate = utils.join_path(dir, string.format("%s_mosaic_%02d.jpg", stem, i))
        i = i + 1
    end

    return candidate, dir
end

local function ensure_directory(dir)
    if not dir or dir == "" then
        return true
    end

    local result = mp.command_native({
        name = "subprocess",
        playback_only = false,
        capture_stdout = true,
        capture_stderr = true,
        args = {"mkdir", "-p", dir},
    })

    return result and result.status == 0
end

local function clamp_integer(value, default, min_value)
    value = tonumber(value) or default
    value = math.floor(value)
    if value < min_value then
        return min_value
    end
    return value
end

local function lower_string(value)
    if value == nil then
        return ""
    end

    return tostring(value):lower()
end

local function format_timestamp(seconds)
    seconds = math.max(0, tonumber(seconds) or 0)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)

    if hours > 0 then
        return string.format("%d:%02d:%02d", hours, minutes, secs)
    end

    return string.format("%02d:%02d", minutes, secs)
end

local function format_duration(seconds)
    seconds = math.max(0, tonumber(seconds) or 0)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)

    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

local function file_size(path)
    local file = io.open(path, "rb")
    if not file then
        return nil
    end

    local size = file:seek("end")
    file:close()
    return size
end

local function format_file_size(bytes)
    bytes = tonumber(bytes)
    if not bytes then
        return "unknown"
    end

    local units = {"B", "KiB", "MiB", "GiB", "TiB"}
    local value = bytes
    local unit = 1

    while value >= 1024 and unit < #units do
        value = value / 1024
        unit = unit + 1
    end

    if unit == 1 then
        return string.format("%d %s", value, units[unit])
    end

    return string.format("%.2f %s", value, units[unit])
end

local function video_resolution()
    local params = mp.get_property_native("video-params", {})
    local width = params and params.w
    local height = params and params.h

    width = width or mp.get_property_number("width")
    height = height or mp.get_property_number("height")

    if not width or not height then
        return "unknown"
    end

    return string.format("%dx%d", width, height)
end

local function source_dimensions()
    local params = mp.get_property_native("video-params", {})
    local width = params and params.w
    local height = params and params.h

    width = width or mp.get_property_number("width")
    height = height or mp.get_property_number("height")

    return width, height
end

local function video_params()
    return mp.get_property_native("video-params", {}) or {}
end

local function is_hdr_or_bt2020_source()
    local params = video_params()
    local primaries = lower_string(params.primaries)
    local gamma = lower_string(params.gamma)
    local colormatrix = lower_string(params.colormatrix)

    return primaries:find("2020", 1, true)
        or colormatrix:find("2020", 1, true)
        or gamma == "pq"
        or gamma == "hlg"
        or gamma:find("2084", 1, true) ~= nil
        or gamma:find("arib", 1, true) ~= nil
end

local function hdr_transfer()
    local gamma = lower_string(video_params().gamma)

    if gamma == "hlg" or gamma:find("arib", 1, true) then
        return "arib-std-b67"
    end

    return "smpte2084"
end

local function should_tonemap_hdr()
    local mode = lower_string(opts.hdr_tonemap)

    if mode == "yes" or mode == "true" or mode == "always" then
        return true
    end

    if mode == "no" or mode == "false" or mode == "never" then
        return false
    end

    return is_hdr_or_bt2020_source()
end

local function hdr_tonemap_filter()
    if not should_tonemap_hdr() then
        return ""
    end

    return string.format(
        "setparams=color_primaries=bt2020:color_trc=%s:colorspace=bt2020nc,zscale=t=linear:npl=%d,format=gbrpf32le,tonemap=tonemap=%s:desat=%s:peak=%d,zscale=t=bt709:p=bt709:m=bt709:r=limited,format=yuv420p,",
        hdr_transfer(),
        clamp_integer(opts.hdr_tonemap_npl, 100, 1),
        opts.hdr_tonemap_algorithm,
        tostring(tonumber(opts.hdr_tonemap_desat) or 0),
        clamp_integer(opts.hdr_tonemap_peak, 1000, 1)
    )
end

local function escape_drawtext(text)
    return text:gsub("\\", "\\\\"):gsub(":", "\\:"):gsub("'", "\\'"):gsub("%%", "\\%%")
end

local function metadata_text(source_path, duration)
    local _, filename = split_path(source_path)
    local lines = {
        "File: " .. filename,
        "Size: " .. format_file_size(file_size(source_path)),
        "Resolution: " .. video_resolution(),
        "Duration: " .. format_duration(duration),
    }

    return escape_drawtext(table.concat(lines, "\n"))
end

local function font_option(name)
    if not name or name == "" then
        return ""
    end

    if name:sub(1, 1) == "/" then
        return ":fontfile='" .. escape_drawtext(name) .. "'"
    end

    return ":font='" .. escape_drawtext(name) .. "'"
end

local function theme()
    if opts.darkmode then
        return {
            background = "black",
            text = "white",
            timestamp_text = "white",
            timestamp_box = "black@0.60",
        }
    end

    return {
        background = "white",
        text = "black",
        timestamp_text = "black",
        timestamp_box = "white@0.70",
    }
end

local function layout_for_grid(columns, rows, width, height, padding)
    local parts = {}

    for row = 0, rows - 1 do
        for column = 0, columns - 1 do
            parts[#parts + 1] = string.format("%d_%d", column * (width + padding), row * (height + padding))
        end
    end

    return table.concat(parts, "|")
end

local function mosaic_settings(columns_override, rows_override)
    local columns = clamp_integer(columns_override or opts.columns, 4, 1)
    local rows = clamp_integer(rows_override or opts.rows, 4, 1)
    local source_width, source_height = source_dimensions()
    local width = clamp_integer(source_width, 320, 16)
    local height = clamp_integer(source_height, 180, 16)
    local margin = clamp_integer(opts.margin, 10, 0)
    local padding = clamp_integer(opts.padding, 4, 0)

    if opts.resize then
        width = clamp_integer(opts.thumb_width, 320, 16)
        height = clamp_integer(opts.thumb_height, 180, 16)
    end

    return columns, rows, width, height, margin, padding
end

local function metadata_font_size(width)
    local configured = tonumber(opts.metadata_font_size) or 0
    if configured > 0 then
        return clamp_integer(configured, 22, 8)
    end

    return math.max(22, math.floor(width / 30))
end

local function metadata_title_font_size(body_size)
    local configured = tonumber(opts.metadata_title_font_size) or 0
    if configured > 0 then
        return clamp_integer(configured, 28, 8)
    end

    return body_size * 2
end

local function make_ffmpeg_args(source_path, out, duration, columns_override, rows_override)
    local columns, rows, width, height, margin, padding = mosaic_settings(columns_override, rows_override)
    local colors = theme()
    local tonemap_filter = hdr_tonemap_filter()
    local cells = columns * rows
    local interval = math.max(duration / cells, 0.001)
    local args = {
        opts.ffmpeg_path,
        "-hide_banner",
        "-loglevel", "error",
        "-y",
    }

    for i = 0, cells - 1 do
        local timestamp = math.min((i + 0.5) * interval, math.max(duration - 0.001, 0))
        args[#args + 1] = "-ss"
        args[#args + 1] = string.format("%.3f", timestamp)
        args[#args + 1] = "-i"
        args[#args + 1] = source_path
    end

    local filters = {}
    local stack_inputs = {}

    for i = 0, cells - 1 do
        local timestamp = math.min((i + 0.5) * interval, math.max(duration - 0.001, 0))
        local chain = string.format(
            "[%d:v]%sscale=%d:%d:force_original_aspect_ratio=decrease,pad=%d:%d:(ow-iw)/2:(oh-ih)/2:color=%s",
            i, tonemap_filter, width, height, width, height, colors.background
        )

        if opts.timestamp then
            chain = chain .. string.format(
                ",drawtext=text='%s'%s:x=8:y=h-th-8:fontsize=%d:fontcolor=%s:box=1:boxcolor=%s",
                escape_drawtext(format_timestamp(timestamp)),
                font_option(opts.timestamp_font),
                clamp_integer(opts.timestamp_font_size, 16, 6),
                colors.timestamp_text,
                colors.timestamp_box
            )
        end

        chain = chain .. string.format("[v%d]", i)
        filters[#filters + 1] = chain
        stack_inputs[#stack_inputs + 1] = string.format("[v%d]", i)
    end

    local grid_width = columns * width + (columns - 1) * padding
    local grid_height = rows * height + (rows - 1) * padding
    local metadata_size = metadata_font_size(width)
    local title_size = metadata_title_font_size(metadata_size)
    local title_gap = clamp_integer(opts.metadata_title_gap, 10, 0)
    local has_title = opts.metadata_title and opts.metadata_title ~= ""
    local line_spacing = clamp_integer(opts.metadata_line_spacing, 2, 0)
    local bottom_padding = clamp_integer(opts.metadata_bottom_padding, 12, 0)
    local header_height = 0
    if opts.metadata then
        local configured_header_height = clamp_integer(opts.metadata_header_height, 120, 0)
        local title_height = 0
        if has_title then
            title_height = math.ceil(title_size * 1.35) + title_gap
        end
        local line_height = math.ceil(metadata_size * 1.35)
        local minimum_header_height = title_height + line_height * 4 + line_spacing * 3 + bottom_padding + margin * 2
        header_height = math.max(configured_header_height, minimum_header_height)
    end

    local final_chain = string.format(
        "%sxstack=inputs=%d:layout=%s:fill=%s,pad=%d:%d:%d:%d:color=%s",
        table.concat(stack_inputs, ""),
        cells,
        layout_for_grid(columns, rows, width, height, padding),
        colors.background,
        grid_width + margin * 2,
        grid_height + margin * 2 + header_height,
        margin,
        margin + header_height,
        colors.background
    )

    if opts.metadata and header_height > 0 then
        local line_height = math.ceil(metadata_size * 1.35)
        local title_height = 0
        if has_title then
            title_height = math.ceil(title_size * 1.35) + title_gap
        end

        local metadata_block_height = title_height + line_height * 4 + line_spacing * 3 + bottom_padding
        local title_y = math.floor((header_height - metadata_block_height) / 2)
        if title_y < margin then
            title_y = margin
        end

        local metadata_y = title_y + title_height

        if has_title then
            final_chain = final_chain .. string.format(
                ",drawtext=text='%s'%s:x=%d:y=%d:fontsize=%d:fontcolor=%s",
                escape_drawtext(opts.metadata_title),
                font_option(opts.metadata_title_font ~= "" and opts.metadata_title_font or opts.metadata_font),
                margin,
                title_y,
                title_size,
                colors.text
            )
        end

        final_chain = final_chain .. string.format(
            ",drawtext=text='%s'%s:x=%d:y=%d:fontsize=%d:fontcolor=%s:line_spacing=%d",
            metadata_text(source_path, duration),
            font_option(opts.metadata_font),
            margin,
            metadata_y,
            metadata_size,
            colors.text,
            line_spacing
        )
    end

    filters[#filters + 1] = final_chain .. "[out]"

    args[#args + 1] = "-filter_complex"
    args[#args + 1] = table.concat(filters, ";")
    args[#args + 1] = "-map"
    args[#args + 1] = "[out]"
    args[#args + 1] = "-frames:v"
    args[#args + 1] = "1"
    args[#args + 1] = "-q:v"
    args[#args + 1] = "3"
    args[#args + 1] = out

    return args, columns, rows
end

local function create_mosaic(columns_override, rows_override)
    local path = mp.get_property("path")
    local duration = mp.get_property_number("duration")

    if not path or path == "" then
        mp.osd_message("No file loaded")
        return
    end

    if path:match("^%a[%w_-]*://") then
        mp.osd_message("Screenshot mosaic needs a local file")
        return
    end

    if not duration or duration <= 0 then
        mp.osd_message("Could not determine video duration")
        return
    end

    local source_path = make_absolute_path(mp.get_property("stream-open-filename", path))
    local out, out_dir = output_path(source_path)
    if not ensure_directory(out_dir) then
        mp.osd_message("Mosaic failed: could not create output directory", 5)
        mp.msg.error("Could not create screenshot mosaic output directory: " .. tostring(out_dir))
        return
    end

    local args, columns, rows = make_ffmpeg_args(source_path, out, duration, columns_override, rows_override)

    mp.osd_message(string.format("Creating %dx%d screenshot mosaic...", columns, rows))
    mp.msg.info("Saving screenshot mosaic to: " .. out)

    mp.command_native_async({
        name = "subprocess",
        playback_only = false,
        capture_stdout = true,
        capture_stderr = true,
        args = args,
    }, function(success, result)
        if success and result.status == 0 then
            mp.osd_message("Mosaic saved: " .. out, 5)
            mp.msg.info("Screenshot mosaic saved: " .. out)

            if opts.open_after_create then
                mp.command_native_async({
                    name = "subprocess",
                    playback_only = false,
                    args = {"xdg-open", out},
                }, function() end)
            end
            return
        end

        local err = result and result.stderr or "unknown error"
        err = err:gsub("%s+$", "")
        local short_err = err:gsub("\n", " ")
        if #short_err > 120 then
            short_err = short_err:sub(1, 120) .. "..."
        end
        mp.osd_message("Mosaic failed: " .. short_err, 8)
        mp.msg.error("Screenshot mosaic failed: " .. err)
    end)
end

mp.add_key_binding("M", "screenshot-mosaic", create_mosaic)
mp.register_script_message("screenshot-mosaic", create_mosaic)
