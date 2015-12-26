function gpio_watch_val(value)
    if value == gpio.LOW or value == "low" then
        value = "high"
    else
        value = "low"
    end

    return value
end

function gpio_watch(pin, callback)
    print("Gpio watch pin " .. pin)
    gpio.mode(pin,gpio.INPUT)
    local value = gpio.read(pin)
    value = gpio_watch_val(value)
    gpio.mode(pin, gpio.INT)
    gpio.trig(pin, value, function(level)
        callback(value)
        value = gpio_watch_val(value)
        gpio.trig(pin, value)
    end)
end