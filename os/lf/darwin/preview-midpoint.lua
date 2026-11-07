local mp = require 'mp'
local clip_seconds = 20

-- Set the initial seek before the decoder displays the first frame.
mp.add_hook('on_preloaded', 50, function()
    local duration = mp.get_property_number('duration')
    if not duration or duration <= 0 or duration == math.huge then return end
    local first = math.max(0, (duration - clip_seconds) / 2)
    local last = math.min(duration, first + clip_seconds)
    mp.set_property('file-local-options/start', string.format('%.6f', first))
    mp.set_property('file-local-options/ab-loop-a', string.format('%.6f', first))
    mp.set_property('file-local-options/ab-loop-b', string.format('%.6f', last))
end)
