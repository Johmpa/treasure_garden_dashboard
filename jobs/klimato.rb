require "net/http"
require "json"

# WOEID for location:
# http://woeid.rosselliot.co.nz
woeid  = 906057

# Units for temperature:
# f: Fahrenheit
# c: Celsius
format = "c"

query  = URI::encode "select * from weather.forecast WHERE woeid=#{woeid} and u='#{format}'&format=json"

SCHEDULER.every "15m", :first_in => 0 do |job|
  http     = Net::HTTP.new "query.yahooapis.com"
  request  = http.request Net::HTTP::Get.new("/v1/public/yql?q=#{query}")
  response = JSON.parse request.body
  results  = response["query"]["results"]

  #puts request.body
  if results
    condition = results["channel"]["item"]["condition"]
    location  = results["channel"]["location"]

    #fulhack pga APIändring
    unit = results["channel"]["units"]["temperature"]
    temp = condition["temp"]
    if unit == "F"
      puts "Farenheit detected"
      temp = ((temp.to_f - 32)*5)/9
    end

    puts temp
    ##
    send_event "klimato", { location: location["city"], temperature: temp.round, code: condition["code"], format: format }
  end
end
