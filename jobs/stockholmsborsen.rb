require 'date'
require 'net/http'
require 'net/https'
require 'uri'
require 'open-uri'
require 'bigdecimal'
require 'time'


initialdatapoints = [[400.7, 1458835811],[410.7, 1458835911],[416.9, 1458836211],[400.7, 1458836511]]
datapoints = []
previousTime = Time.new()
prevMinimum = -1;

#SCHEDULER.every "1m", :first_in => 0 do |job|
SCHEDULER.cron '*/5 9-17 * * 1-5' do |job|
  puts "OMXSPI: Updating"
  source = open('https://bors-nliv.svd.se/', {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}, &:read)

  #  <h2 class="resource-flag sweden">OMX-S</h2><span class="result"><span class="time">Kl 17:30:</span> &nbsp; 476,42 &nbsp; <span class="pos">+0,11%</span></span>
  #puts source

  #puts /.*resource-flag sweden">OMX-S.*/.match(source)
  #puts /.*resource-flag sweden">OMX-S.*\n.*<span class="time">Kl .*:.*/.match(source)
  currentvalue =  /.*resource-flag sweden">OMX-S.*\n.*<span class="time">Kl (.*):<.span> &nbsp. (.*) &nbsp; <span class=.*>.*/.match(source)[2]
  percentage =    /.*resource-flag sweden">OMX-S.*\n.*<span class="time">Kl (.*):<.span> &nbsp. (.*) &nbsp; <span class=.*>(.*)<.span><.span>/.match(source)[3] # Fult men orka
  currentvalue = currentvalue.gsub(",",".") # Fixa amerikanskt decimaltecken
  currentvalue = currentvalue.gsub(" ","") # Få bort eventuellt mellanslag i siffran

  puts "OMXSPI: Current Value: " + currentvalue
  puts "OMXSPI: Percentage:"
  #puts percentage
  percentage = percentage.gsub("&minus;","-")
  percentage = percentage.gsub("</span>", "") # Fulhack, men orka
  #puts "OMXSPI: Trimmed Percentage:"
  #puts percentage

  currentTime = Time.new
  #puts "OMXSPI: Current Time: " + currentTime.to_s

  if (currentTime.day() != previousTime.day())
    datapoints = []
  end


  datapoints << [BigDecimal.new(currentvalue).to_f, currentTime.to_i]

  #puts "OMXSPI: Datapoints - "
  #puts datapoints

  omxseries = {target: "OMXSPI", datapoints: datapoints}

  #puts "OMXSPI: Omxseries - "
  #puts omxseries

  #puts "OMXSPI: Minimum - "
  #puts datapoints.min[0]

  newMinimum = datapoints.min != prevMinimum
  #puts newMinimum

  send_event('stockholmsborsen', series: [omxseries], minimum: datapoints.min[0]-2, displayedValue: percentage, needsclear: newMinimum)

  previousTime = currentTime
  prevMinimum = datapoints.min
end
