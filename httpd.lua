function httpd_urldecode(s)
    s = s:gsub('+', ' '):gsub('%%(%x%x)',
        function(h)
            return string.char(tonumber(h, 16))
        end)
    return s
end

function httpd_get_params(s)
  local params = {}
  for k, v in string.gmatch(s, "(%w+)=([%w%%+]+)") do
     params[k] = httpd_urldecode(v)
  end
  return params
end

function httpd_get_request(payload)
    local r = {}
    r.query = string.sub(payload, string.find(payload, "/"), string.find(payload, " HTTP"))
    print("Query:" .. r.query)
    local has_params = string.find(r.query, "?")
    if has_params then
        r.route = string.sub(r.query, 0, has_params-1)
        print("Route:" .. r.route)
        local gets = string.sub(r.query, has_params+1,-1)
        print("Gets:" .. gets)
        r.get = httpd_get_params(gets)
    else
        r.route = r.query
        r.get = {}
    end

    return r
end

function httpd_init()
    if srv then
        srv:close()
    end
    srv=net.createServer(net.TCP) 
    srv:listen(80,function(conn) 
        conn:on("receive",function(conn,payload) 
            req = httpd_get_request(payload) 
            httpd_routes(conn,req)
            conn:close()
            collectgarbage()
        end) 
    end)
end

function httpd_routes(conn,req)
    conn:send("("..tmr.time()..") No route defined.")
end