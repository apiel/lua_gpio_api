function httpd_routes(conn,req)    
    local do404 = true
    do404 = do404 and not gpio_action(conn, req)
    do404 = do404 and not wifi_action(conn, req)

    -- set url to ping about status every min
    -- set pin to watch on start
    -- set pin to watch
    
    if do404 then
        conn:send("("..tmr.time()..") 404 Not Found")
    end
end
