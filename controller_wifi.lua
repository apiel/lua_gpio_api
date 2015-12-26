function wifi_action(conn, req)
    local action = string.match(req["route"], "\/wifi\/(%w+)")
    local is_wifi_action = action
    if is_wifi_action then
        if action == "set" then
            wifi_set_action(conn, req)
        else 
            conn:send("Unknown wifi action")
        end
    end

    return is_wifi_action
end

function wifi_set_action(conn, req)
    if req["get"]["ssid"] and req["get"]["password"] then
        wifi_save_config(req["get"]["ssid"], req["get"]["password"])
        conn:send("DONE")
    else
        conn:send("Please provide ssid and password");
    end
end