local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local vicious = require("vicious")
local naughty = require("naughty")

-- {{{ BATTERY
-- Charge %
batpct = wibox.widget.textbox()
vicious.register(
    batpct, vicious.widgets.bat,"$1 $2%", nil, "BAT0")
-- End Battery}}}

-- {{{ VOLUME
-- Cache
vicious.cache(vicious.widgets.volume)
-- Volume %
volpct = wibox.widget.textbox()
vicious.register(volpct, vicious.widgets.volume, "$2 $1%", nil, "Master")
-- End Volume }}}

-- {{{ Start CPU
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
--
cpu = wibox.widget.textbox()
vicious.register(cpu, vicious.widgets.cpu, "All: $1% 1: $2% 2: $3% 3: $4% 4: $5%", 2)
-- End CPU }}}
--
-- {{{ Start Mem
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_ram)
--
mem = wibox.widget.textbox()
vicious.register(mem, vicious.widgets.mem,
                 "Mem: $1% Use: $2MB Total: $3MB Free: $4MB Swap: $5%", 2)
-- End Mem }}}

-- {{{ Start Wifi
wifiicon = wibox.widget.imagebox()
wifiicon:set_image(beautiful.widget_wifi)
--
wifi = wibox.widget.textbox()
vicious.register(wifi, vicious.widgets.wifi,
                 "${ssid} Rate: ${rate}MB/s Link: ${linp}%", 3, "wlan0")
-- End Wifi }}}
