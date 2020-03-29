local beautiful = require("beautiful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local GET_BRIGHTNESS_CMD = 'sudo light'

local widget = {}

local function worker(args)

    local args = args or {}

    local main_color = args.main_color or beautiful.fg_normal
    local bg_color = args.bg_color or '#ffffff11'
    local width = args.width or 50
    local shape = args.shape or 'bar'
    local margins = args.margins or 10

    local get_brightness_cmd = args.get_brightness_cmd or GET_BRIGHTNESS_CMD

    local brightness_bar_widget = wibox.widget {
        max_value = 1,
        forced_width = width,
        color = main_color,
        background_color = bg_color,
        shape = gears.shape[shape],
        margins = {
            top = margins,
            bottom = margins,
        },
        widget = wibox.widget.progressbar
    }

    local update_graphic = function(widget, stdout, _, _, _)
        local brightness = string.match(stdout, "%d+")
        brightness = tonumber(string.format(brightness, "%d"))

        widget.value = brightness / 100
    end

    watch(get_brightness_cmd, 1, update_graphic, brightness_bar_widget)

    return brightness_bar_widget
end

return setmetatable(widget, { __call = function(_, ...) return worker(...) end })

