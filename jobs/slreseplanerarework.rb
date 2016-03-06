require 'net/http'
require 'net/https'
require 'uri'
require 'json'

key             = URI::encode('2ca36fc1304f4bc7ac9c87cf40b0dc06')
uri             = URI.parse("http://api.sl.se/api2/TravelplannerV2/trip.JSON?key=#{key}&originId=9103&destId=9295&unsharp=1&numTrips=1&realtime=true")

# 10000 anrop per månad har jag råd med -> drygt 13 anrop per timme
SCHEDULER.every "10m", :first_in => 0 do |job|
  http     = Net::HTTP.new "api.sl.se"
  request  = http.request Net::HTTP::Get.new("/api2/TravelplannerV2/trip.JSON?key=#{key}&originId=9103&destId=9295&unsharp=1&numTrips=1&realtime=true")
  response = JSON.parse request.body
  puts response["TripList"]

=begin
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
=end
  puts "Send Event Planerare..."
  send_event "slreseplanerarework", response
end
