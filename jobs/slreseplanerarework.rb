require 'net/http'
require 'net/https'
require 'uri'
require 'json'

$key = URI::encode('2ca36fc1304f4bc7ac9c87cf40b0dc06')
#$uri             = URI.parse("http://api.sl.se/api2/TravelplannerV2/trip.JSON?key=#{key}&originId=9103&destId=9295&unsharp=1&numTrips=1&realtime=true")

# 10000 anrop per månad har jag råd med -> drygt 13 anrop per timme
#SCHEDULER.every "10m", :first_in => 0 do |job|
#SCHEDULER.cron '*/5 9-17 * * 1-5' do |job|
SCHEDULER.cron '*/2 6-10 * * 1-5' do
  puts "Sl Travel Plan: Frequent Calc"
  calculateTripAndSend
end
SCHEDULER.cron '*/30 10-20 * * 1-5' do
  puts "Sl Travel Plan: Sparse calc"
  calculateTripAndSend
end

def calculateTripAndSend
  targetTime = Time.now + 8*60
  puts "Sl Travel Plan: Target Time - " + targetTime.strftime("%H:%M")
  http = Net::HTTP.new "api.sl.se"
  request = http.request Net::HTTP::Get.new("/api2/TravelplannerV2/trip.JSON?key=#{$key}&originId=9103&destId=9295&unsharp=1&numTrips=1&realtime=true&time=#{targetTime.strftime("%H:%M")}")
  response = JSON.parse request.body
  #puts response["TripList"]
  response["TripList"]["Trip"]["LegList"]["Leg"].delete_if { |value| value["Origin"]["name"] == value["Destination"]["name"] }
  puts "Sl Travel Plan: Send Event..."
  send_event "slreseplanerarework", response
end
