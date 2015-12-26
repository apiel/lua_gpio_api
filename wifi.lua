function wifi_save_config(ssid, pwd)
  file.open("wifi_cfg.lua", "w+")
  file.writeline("wifi.sta.config(\"" .. ssid .. "\",\"" .. pwd .. "\")")
  print("Wifi config saved")
  file.close()
end

function wifi_sta()
  wifi.setmode(wifi.STATION)
  dofile("wifi_cfg.lua")
  wifi.sta.connect()
end

function wifi_ap()
  local cfg={}
  cfg.ssid="nodemcu_bathrom"
  cfg.pwd="passpass"
  wifi.ap.config(cfg)

  local cfg={}
  cfg.ip="192.168.1.1";
  cfg.netmask="255.255.255.0";
  cfg.gateway="192.168.1.1";
  wifi.ap.setip(cfg);
  wifi.setmode(wifi.SOFTAP)

  print("Wifi AP started")
  print("MAC:"..wifi.ap.getmac().."\r\nIP:"..wifi.ap.getip());
end

function wifi_watcher()
end

function wifi_init()
  wifi_sta()
  local cnt = 0
  tmr.alarm(0, 1000, 1, function() 
     ip = wifi.sta.getip()
     if (ip == nil) and (cnt < 20) then 
        print("Wifi waiting for IP...")
        cnt = cnt + 1
     elseif ip then
        tmr.stop(0);
        print("Wifi connected: " .. ip)
        wifi_watcher()
     else 
        tmr.stop(0);
        wifi_ap()
     end 
  end)
end
