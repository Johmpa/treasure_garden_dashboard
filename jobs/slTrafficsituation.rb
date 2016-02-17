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
  puts response["ResponseData"]

  response["ResponseData"]["TrafficTypes"].each do |traffictype|

  end
end
