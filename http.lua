function http_send_request(url)
    local request = http_parse_url(url)
    if http_is_ip(request.domain) then
        request.ip = request.domain
        http_send_request_to_ip(request)
    else
        http_get_ip(request.domain, function(ip)
            request.ip = ip
            http_send_request_to_ip(request)
        end)
    end
end

function http_send_request_to_ip(request)
    local conn=net.createConnection(net.TCP, false) 
    local port = 80
    if request.port ~= "" then port = request.port end
    conn:connect(port,request.ip)
    conn:send("GET " .. request.uri .. " HTTP/1.1\r\nHost: " .. request.domain .. "\r\n"
        .."Connection: keep-alive\r\nAccept: */*\r\n\r\n")
end

function http_get_ip(domain, callback)
    ip = nil
    sk=net.createConnection(net.TCP, 0)
    sk:dns(domain,function(conn,ip)
        conn:close()
        callback(ip)
    end)
    return ip
end

function http_parse_url(url)
    local request = {}
    local pattern = "http://([%w-_%.]+):?(%d*)([%w-_%.%?%./%+=&]+)"
    request.domain, request.port, request.uri = string.match(url, pattern)
    
    return request
end

function http_is_ip(domain)
    local pattern = "^%d%d?%d?.%d%d?%d?.%d%d?%d?.%d%d?%d?$"
    return string.match(domain, pattern) ~= nil
end

-- local url =  "http://www.alexparadise.com/api/auth?workspace=test"
-- http_send_request(url)

