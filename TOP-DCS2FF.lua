local broadcastIP = '192.168.1.255' -- Look at your own network IP addresses to and replace the last number by 255
package.path  = package.path..";"..lfs.currentdir().."/LuaSocket/?.lua"
package.cpath = package.cpath..";"..lfs.currentdir().."/LuaSocket/?.dll"
local socket = require("socket")
local port = 49002

function LuaExportStart()
  TOPSocket = socket.udp()
  TOPSocket:setsockname("*", port)
  TOPSocket:setoption('broadcast', true)
  TOPSocket:settimeout(.1)

  log.write('TOP-DCS2FF',log.INFO, "Initialized correctly")
end

function LuaExportActivityNextEvent()
  local time = LoGetModelTime()
  local selfData = LoGetSelfData()
  if selfData == nil then return time + 1.0 end

  local pitch, bank, yaw = LoGetADIPitchBankYaw()
  local TAS = LoGetTrueAirSpeed()

  local o = LoGetWorldObjects()
  for k,v in pairs(o) do
    if v.Type.level1 == 1 and v.Type.level2 ~= 3 then
        local groundAltitude = LoGetAltitude(v.Position.x, v.Position.z)
        local inFlight
        if v.LatLongAlt.Alt - groundAltitude < 10 then inFlight = 0 else inFlight = 1 end
        local TRAFFICMessage = string.format( "XTRAFFICDCS2FF,%d,%.3f,%.3f,%.1f,%d,%d,%.1f,%.1f,%s", k, v.LatLongAlt.Lat, v.LatLongAlt.Long, v.LatLongAlt.Alt * 3.28, 0, inFlight, math.deg(v.Heading), 0, v.Name)
        socket.try(TOPSocket:sendto(TRAFFICMessage, broadcastIP, port))
    end
  end


  local GPSmessage = string.format( "XGPSDCS2FF,%.3f,%.3f,%.1f,%.1f,%.1f", selfData.LatLongAlt.Long, selfData.LatLongAlt.Lat, selfData.LatLongAlt.Alt, math.deg(selfData.Heading), TAS)
  local ATTmessage = string.format( "XATTDCS2FF,%.1f,%.1f,%1.f", math.deg(selfData.Heading), math.deg(pitch), math.deg(bank))
  socket.try(TOPSocket:sendto(GPSmessage, broadcastIP, port))
  socket.try(TOPSocket:sendto(ATTmessage, broadcastIP, port))
  return time + 1.0
end
