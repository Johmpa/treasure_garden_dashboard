require 'net/http'
require 'net/https'
require 'uri'
require 'open-uri'

# Populate the graph with some random points
points = [{x:1,y:2},{x:2, y:-2},{x:3, y:4}]
#last_x = points.last[:x]
SCHEDULER.every "10m", :first_in => 0 do |job|
  source = open('http://www.dn.se/ekonomi/bors/bors-hem/', &:read)

  #puts source
  percentagechange =  /.*<li>OMXSPI<span class=.*>(.*)<.*><.li>/.match(source)[1]
  time =  /.*ctl00_MainContent_ctl01_marketIndexChart_chartTitleTime.*time.*>(.*)<.*>/.match(source)[1]

  puts percentagechange
  puts time

  # TODO: Lägg till percentagechange i grafen på riktigt
  #last_x += 1
  #points << { x: time, y: percentagechange }
  puts points

  send_event('stockholmsborsen', points: points)
end
