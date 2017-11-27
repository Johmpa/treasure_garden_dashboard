require 'net/http'
require 'net/https'
require 'uri'
require 'json'

home_location = URI::encode('59.3674343,17.8718877')
key             = URI::encode('q3sgmezmvtwn4erc4t5rkpe3')
locations       = [{ name: "Com Hem", location: URI::encode('59.3331998,18.0416967')},
                   { name: "Cygni HQ", location: URI::encode('59.334812,18.069467')},
                  # { name: "Roslagshallen", location: URI::encode('59.347187,18.059262')},
                   { name: "Föräldrar", location: URI::encode('59.373535,17.905214')},
                   #{ name: "Tim", location: URI::encode('59.356455,17.888587')},
                   { name: "Chrille & Sara", location: URI::encode('59.5792748,17.4825038')},
                   { name: "Micke / Andreas", location: URI::encode('59.362983,17.945802')}
]
#locations << { name: "Pensionsmyndigheten", location: URI::encode('59.3155173,18.032994')}

SCHEDULER.every '10m', :first_in => '15s' do |job|
    routes = []

    # pull data
    locations.each do |location|
        uri = URI.parse("https://api.tomtom.com/routing/1/calculateRoute/#{home_location}:#{location[:location]}/json?routeType=fastest&traffic=true&travelMode=car&key=#{key}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        routes << { name: location[:name], location: location[:location], route: JSON.parse(response.body)["routes"][0] }
    end

    # find winner
    if routes
        routes.sort! { |route1, route2| route2[:route]["summary"]["travelTimeInSeconds"] <=> route1[:route]["summary"]["travelTimeInSeconds"] }
        routes.map! do |r|
            { name: r[:name],
                time: seconds_in_words(r[:route]["summary"]["travelTimeInSeconds"].to_i),
                road: delay(r[:route]["summary"]["trafficDelayInSeconds"])}
        end
    end

    # send event
  send_event('tomtom', { results: routes } )
end

def seconds_in_words(secs)
    m, s = secs.divmod(60)
    h, m = m.divmod(60)

    plural_hours = if h > 1 then "s" else "" end
    plural_minutes = if m > 1 then "s" else "" end

    if secs >= 3600
        "#{h} hour#{plural_hours}, #{m} min#{plural_minutes}"
    else
        "#{m} min#{plural_minutes}"
    end
end

def delay(delay_seconds)
    m, s = delay_seconds.divmod(60)
    h, m = m.divmod(60)

    if delay_seconds >= 60
        "#{m} min delay"
    elsif delay_seconds == 0
        ""
    else
        "#{s} sec delay"
    end
end