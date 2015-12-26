function gpio_action(conn, req)
    local action, pin = string.match(req["route"], "\/gpio\/(%w+)\/([%d]+)")
    local is_gpio_action = action and pin
    if is_gpio_action then
        pin = tonumber(pin)
        if pin < 0 or pin > 12 then
            conn:send("Gpio pin " .. pin .. " unknown (0 - 12)")
        elseif action == "on" then
            gpio.mode(pin,gpio.OUTPUT)
            gpio.write(pin,gpio.HIGH)        
            conn:send("DONE")
        elseif action == "off" then
            gpio.mode(pin,gpio.OUTPUT)
            gpio.write(pin,gpio.LOW)        
            conn:send("DONE")
        elseif action == "read" then
            gpio.mode(pin,gpio.INPUT)
            conn:send(gpio.read(pin))
        elseif action == "watch" then
            if req["get"]["url"] then
                gpio_watch(pin, function(value)
                    print("watch " .. tmr.now() .. " value " .. value .. " url " .. req["get"]["url"]) 
                    http_send_request(req["get"]["url"])   
                end)   
                conn:send("WATCHER RUNNING")             
            else
                conn:send("You must specify a callback url")
            end
        else 
            conn:send("Unknown gpio action")
        end
    end

    return is_gpio_action
end
