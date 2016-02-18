require 'net/http'
require 'net/https'
require 'uri'
require 'json'

key             = URI::encode('efa14a1df26a400eb762439cd165e527')
uri             = URI.parse("api.sl.se/api2/trafficsituation.JSON?key=#{key}")

SCHEDULER.every "15m", :first_in => 0 do |job|
  http     = Net::HTTP.new "api.sl.se"
  request  = http.request Net::HTTP::Get.new("/api2/trafficsituation.JSON?key=#{key}")
  response = JSON.parse request.body
  #puts response["ResponseData"]

  train = {}
  metro = {}
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
  end
  puts "Send Event..."
  send_event "sltrafficsituation", {Train: train, Metro: metro}
end
