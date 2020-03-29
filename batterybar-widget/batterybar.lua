local beautiful = require("beautiful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local GET_CPACITY_CMD = 'cat /sys/class/power_supply/BAT0/capacity'

local widget = {}

local function worker(args)

    local args = args or {}

    local main_color = args.main_color or beautiful.fg_normal
    local bg_color = args.bg_color or '#ffffff11'
    local width = args.width or 50
    local shape = args.shape or 'bar'
    local margins = args.margins or 10

    local get_capacity_cmd = args.get_capacity_cmd or GET_CPACITY_CMD 

    local capaciy_bar_widget = wibox.widget {
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
        local capacity = string.match(stdout, "%d+")
        capacity = tonumber(string.format(capacity, "%d+"))
       
        if capacity < 20 then
            capaciy_bar_widget.color = '#ffffff'
        elseif capacity > 20 then
            capaciy_bar_widget.color = '#dd7722'
        end

        widget.value = capacity / 100
    end

    watch(get_capacity_cmd, 60, update_graphic, capaciy_bar_widget)

    return capaciy_bar_widget
end

return setmetatable(widget, { __call = function(_, ...) return worker(...) end })