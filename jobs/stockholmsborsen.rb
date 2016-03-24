require 'date'
require 'net/http'
require 'net/https'
require 'uri'
require 'open-uri'
require 'bigdecimal'
require 'time'


initialdatapoints = [[400.7, 1458835811],[410.7, 1458835911],[416.9, 1458836211],[400.7, 1458836511]]
datapoints = initialdatapoints
previousTime = Time.new()

SCHEDULER.every "10m", :first_in => 0 do |job|
  source = open('http://bors-nliv.svd.se/', &:read)

  #  <span class="result"><span class="time">Kl 13:00:</span> &nbsp; 475,89 &nbsp; <span class="neg">&minus;1,16%</span>
  #puts source
  currentvalue =  /.*<span class="result"><span class="time">Kl (.*):<.span> &nbsp. (.*) &nbsp; <span class="neg">.*/.match(source)[2]
  percentage =  /.*<span class="result"><span class="time">Kl (.*):<.span> &nbsp. (.*) &nbsp; <span class="neg">(.*).*/.match(source)[3] # Fult men orka
  currentvalue = currentvalue.gsub(",",".")
  percentage = percentage.gsub("&minus;","-")
  percentage = percentage.gsub("</span>", "") # Fulhack, men orka

  puts "Percentage:"
  puts percentage

  currentTime = Time.new()

  if (currentTime.day() != previousTime.day())
    datapoints = []
  end
  puts currentTime
  puts currentTime.to_i

  puts "Datapoints:"

  datapoints << [BigDecimal.new(currentvalue).to_f, currentTime.to_i]

  puts datapoints

  omxseries = {target: "OMXSPI", datapoints: datapoints}

  puts "Omxseries:"
  puts omxseries

  puts datapoints.min[0]

  send_event('stockholmsborsen', series: [omxseries], minimum: datapoints.min[0]-10, displayedValue: percentage)

  previousTime = currentTime
end
