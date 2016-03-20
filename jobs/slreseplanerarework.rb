require 'net/http'
require 'net/https'
require 'uri'
require 'json'

key             = URI::encode('2ca36fc1304f4bc7ac9c87cf40b0dc06')
uri             = URI.parse("http://api.sl.se/api2/TravelplannerV2/trip.JSON?key=#{key}&originId=9103&destId=9295&unsharp=1&numTrips=1&realtime=true")

# 10000 anrop per månad har jag råd med -> drygt 13 anrop per timme
# TODO: Gör en cron av detta - en varannan minut eller så klockan 06:00 till 10:00
SCHEDULER.every "10m", :first_in => 0 do |job|
  http     = Net::HTTP.new "api.sl.se"
  request  = http.request Net::HTTP::Get.new("/api2/TravelplannerV2/trip.JSON?key=#{key}&originId=9103&destId=9295&unsharp=1&numTrips=1&realtime=true")
  response = JSON.parse request.body
  #puts response["TripList"]

  puts "Send Event Planerare..."
  send_event "slreseplanerarework", response
end
