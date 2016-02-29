require 'net/http'
require 'net/https'
require 'uri'
require 'json'

key             = URI::encode('efa14a1df26a400eb762439cd165e527')
uri             = URI.parse("api.sl.se/api2/trafficsituation.JSON?key=#{key}")

# 10000 anrop per månad har jag råd med -> drygt 13 anrop per timme
SCHEDULER.every "10m", :first_in => 0 do |job|
  http     = Net::HTTP.new "api.sl.se"
  request  = http.request Net::HTTP::Get.new("/api2/trafficsituation.JSON?key=#{key}")
  response = JSON.parse request.body
  #puts response["ResponseData"]

  train = {}
  metro = {}
  bus = {}
  local = {}
  response["ResponseData"]["TrafficTypes"].each do |traffictype|
    type = traffictype["Type"]
    events = traffictype["Events"]
    icon = traffictype["StatusIcon"]

    if type == "train"
      train = {StatusIcon: icon, Events: events}
    end
    if type == "metro"
      metro = {StatusIcon: icon, Events: events}
    end
    if type == "bus"
      bus = {StatusIcon: icon, Events: events}
    end
    if type == "local"
      local = {StatusIcon: icon, Events: events}
    end
  end
  puts "Send Event..."
  send_event "sltrafficsituation", {Train: train, Metro: metro, Bus: bus, Local: local}
end
