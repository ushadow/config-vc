battery_widget = widget({type = "textbox", name = "battery_textbox",
                         align = "right"})

--battery_timer = timer({timeout = 20})
--battery_timer:add_signal("timeout", function() batteryCheck("BAT0") end)
--battery_timer:start()
--
function batteryInfo(adapter)
  local fcur = io.open("/sys/class/power_supply/"..adapter.."/power_now")    
  local fcap = io.open("/sys/class/power_supply/"..adapter.."/energy_full")
  local fsta = io.open("/sys/class/power_supply/"..adapter.."/status")
  if fcur and fcap and fsta then
    local cur = fcur:read()
    local cap = fcap:read()
    local sta = fsta:read()
    local battery = math.floor(cur * 100 / cap)
    if sta:match("Charging") then
      dir = "^"
    elseif sta:match("Discharging") then
      dir = "v"
    else
      dir = ""
    end
    fcur:close()
    fcap:close()
    fsta:close()
    return {battery, dir}
  end
end

function batteryShow(adapter)
  local batInfos =  batteryInfo(adapter)
  if batInfos then
    local battery = batInfos[1]
    local dir = batInfos[2]
    infos = " " .. dir .. battery .. "% " 
  else
    infos = "absente"
  end
  naughty.notify({title = "Batterie",text = infos})
end

function batteryCheck(adapter)
  local batInfos = batteryInfo(adapter)
  if batInfos then
    local battery = batInfos[1]
    local dir = batInfos[2]
    if dir:match("v") and tonumber(battery) < 10 then
      naughty.notify({ preset = naughty.config.presets.critical,
      title = "Batterie Low",
      text = " ".. battery .. "% left",
      timeout = 30,
      font = "Liberation 11", })
    end
    infos = " " .. dir .. battery .. "% "
  else
    infos = "A/C"
  end
  battery_widget.text = infos
end

battery_adapter = "BAT0"
batteryCheck(battery_adapter)
awful.hooks.timer.register(20, function() batteryCheck(battery_adapter) end)
