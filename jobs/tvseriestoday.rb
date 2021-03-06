require 'date'
require 'net/http'
require 'net/https'
require 'uri'
require 'open-uri'
require 'bigdecimal'
require 'time'
require 'openssl'
require 'json'

# API: https://api.thetvdb.com/swagger


url = "https://api.thetvdb.com"
apikey = "51F6746BE38B32BF"
authentication_token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE0ODEyODUyNDQsImlkIjoiVHJlYXN1cmUgR2FyZGVuIERhc2hib2FyZCIsIm9yaWdfaWF0IjoxNDgxMTk4ODQ0fQ.ENsbnaNvL_BJzu3xl17W-ij5-mENbdhH75YHSPA3jY7jkceoNcRr-d3bQxZg4BItBnfZB6f-w-QLhfxwJO822MqGRmAse9oh6rhfElVE0-ELBcq_vZIT1TScLJzg6mLVux9XaoN-3rq9VXl4GdGiKzjxOYEtJwR_KueJ1rk8uDSxLkXAoaTVJf3mXyg_mm_D4elRoOlw1wXhFbYrA3_SCo_wXP6lirBMK8KfmhX82KHnqxIvt4Dk2H2qnyfUGBoAaTBjf9mxrW5O_JwtXXVi7uXYeXfRM95lNKHUqtA73acqKv5F4avbsq2MqDlUygAfyynrwF8EGe-kIAHkTersiA"
series = [
    {name: "Arrow", id: "257655", offset: 1, source: "BTN"},
    {name: "DC's Legends of Tomorrow", id: "295760", offset: 1, source: "Netflix"},
    {name: "Star Wars Rebels", id: "283468", offset: 1, source: "BTN"},
    {name: "The Grand Tour", id: "314087", offset: 0, source: "Amazon Prime"},
    {name: "Marvels Agents of S.H.I.E.L.D.", id: "263365", offset: 1, source: "BTN"},
    {name: "The Man in the High Castle", id: "295829", offset: 1, source: "Amazon Prime"},
    {name: "Sense8", id: "268156", offset: 0, source: "Netflix"},
    {name: "Doctor Who", id: "78804", offset: 1, source: "BTN"},
    {name: "James May: The Reassembler", id: "309339", offset: 1, source: "BTN / Youtube"},
    {name: "Drifters", id: "312559", offset: 0, source: "Crunchyroll"},
    {name: "Sherlock", id: "176941", offset: 0, source: "Netflix"},
    {name: "Colony", id: "284210", offset: 1, source: "BTN"},
    {name: "The Flash", id: "279121", offset: 1, source: "BTN"},
    {name: "The Magicians", id: "299139", offset: 0, source: "HBO Nordic"},
    {name: "The Expanse", id: "280619", offset: 0, source: "Amazon Prime"},
    {name: "Last Week Tonight with John Oliver", id: "278518", offset: 1, source: "HBO Nordic"},
    {name: "Marvel's Iron Fist", id: "317953", offset: 0, source: "Netflix"},
    {name: "Westworld", id: "296762", offset: 1, source: "HBO Nordic"},
    {name: "12 Monkeys", id: "272644", offset: 1, source: "HBO Nordic"},
    {name: "Game of Thrones", id: "121361", offset: 1, source: "HBO Nordic"},
    {name: "Dark Matter", id: "292174", offset: 1, source: "BTN"},
    {name: "Galavant", id: "281619", offset: 1, source: "BTN"},
    {name: "House of Cards", id: "262980", offset: 0, source: "Netflix"},
    {name: "James May's Man Lab", id: "202351", offset: 1, source: "BTN"},
    {name: "James May's Cars of the People", id: "284341", offset: 1, source: "Amazon Prime"},
    {name: "Kabaneri of the Iron Fortress", id: "305082", offset: 1, source: "BTN"},
    {name: "Marvel's Daredevil", id: "281662", offset: 0, source: "Netflix"},
    {name: "Marvel's Jessica Jones", id: "284190", offset: 0, source: "Netflix"},
    {name: "Marvel's Luke Cage", id: "304219", offset: 0, source: "Netflix"},
    {name: "Marvel's The Defenders", id: "326490", offset: 0, source: "Netflix"},
    {name: "Overlord", id: "294002", offset: 0, source: "Crunchyroll"},
    {name: "Re:Zero - Starting Life in Another World", id: "305089", offset: 0, source: "Crunchyroll"},
    {name: "Silicon Valley", id: "277165", offset: 1, source: "HBO Nordic"},
    {name: "Stranger Things", id: "305288", offset: 0, source: "Netflix"},
    {name: "The Crown", id: "305574", offset: 0, source: "Netflix"},
    {name: "The Last Ship", id: "269533", offset: 1, source: "BTN"},
    {name: "The Shanarra Chronicles", id: "289096", offset: 1, source: "HBO Nordic"},
    {name: "The X-Files", id: "77398", offset: 1, source: "BTN"},
    {name: "Top Gear", id: "74608", offset: 1, source: "BTN"},
    {name: "Voltron: Legendary Defender", id: "307899", offset: 0, source: "Netflix"},
    {name: "Taboo", id: "292157", offset: 0, source: "HBO Nordic"},
    {name: "Legion", id: "320724", offset: 1, source: "BTN"},
    {name: "American Gods", id: "253573", offset: 1, source: "Amazon Prime"},
    {name: "Dirk Gently's Holistic Detective Agency", id: "312505", offset: 0, source: "Netflix"},
    {name: "Roman Empire", id: "319594", offset: 0, source: "Netflix"},
    {name: "The Great War", id: "286334", offset: 0, source: "Youtube"},
    {name: "Saga of Tanya the Evil", id: "315500", offset: 0, source: "Crunchyroll"},
    {name: "The Jimquisition", id: "298774", offset: 0, source: "Youtube"},
    {name: "Man at Arms", id: "274046", offset: 0, source: "Youtube"},
    {name: "The Orville", id: "328487", offset: 1, source: "BTN"},
    {name: "Star Trek Discovery", id: "328711", offset: 1, source: "Netflix"},
    {name: "Around the Verse", id: "282890", offset: 0, source: "Youtube"},
    {name: "Knightfall", id: "323608", offset: 1, source: "HBO Nordic"},
    {name: "Marvel's The Punisher", id: "331980", offset: 0, source: "Netflix"},
    {name: "Izetta, the Last Witch", id: "313867", offset: 0, source: "Crunchyroll"},
    {name: "One-Punch Man", id: "293088", offset: 0, source: "Crunchyroll"},
    {name: "Violet Evergarden", id: "330139", offset: 0, source: "Netflix"},
    {name: "Counterpart", id: "337302", offset: 0, source: "Netflix"},
    {name: "Explained", id: "347903", offset: 0, source: "Netflix"},
    {name: "Space Battleship Yamato 2199", id: "259675", offset: 0, source: "Tokyo Tosho"},
    {name: "Attack on Titan", id: "267440", offset: 1, source: "Crunchyroll"},
    {name: "The Chilling Adventures of Sabrina", id: "338947", offset: 0, source: "Netflix"},
    {name: "Medal of Honor", id: "353913", offset: 0, source: "Netflix"},
    {name: "Castlevania", id: "329065", offset: 0, source: "Netflix"},
    {name: "Star Wars: Resistance", id: "351575", offset: 1, source: "BTN"},
    {name: "The Mandalorian", id: "356693", offset: 0, source: "Disney+"},
    {name: "DC's Titans", id: "341663", offset: 0, source: "Netflix"},
    {name: "Patriot Act with Hasan Minhaj", id: "351269", offset: 0, source: "Netflix"},
    {name: "Love, Death & Robots", id: "357888", offset: 0, source: "Netflix"},
    {name: "Kingdom", id: "360366", offset: 0, source: "Netflix"},
    {name: "Good Omens", id: "359569", offset: 0, source: "Amazon Prime"},
    {name: "Vinland Saga", id: "359274", offset: 0, source: "Amazon Prime"},
    {name: "Crash Course: European History", id: "361839", offset: 0, source: "Youtube"},
    {name: "Kurzgesagt - In a Nutshell", id: "287953", offset: 0, source: "Youtube"},
    {name: "Cop Craft", id: "361491", offset: 0, source: "BTN"},
    {name: "The Terror", id: "6786334", offset: 1, source: "Amazon Prime"},
    {name: "The Boys", id: "7140390", offset: 0, source: "Amazon Prime"},
    {name: "Carnival Row", id: "365026", offset: 0, source: "Amazon Prime"},
    {name: "Star Wars: The Clone Wars", id: "83268", offset: 0, source: "Disney+"},
    {name: "His Dark Materials", id: "360295", offset: 1, source: "BTN"},
    {name: "For All Mankind", id: "356202", offset: 1, source: "BTN"},
    {name: "The Witcher", id: "362696", offset: 0, source: "Netflix"},
    {name: "Star Trek: Picard", id: "364093", offset: 0, source: "Amazon Prime"},
    {name: "Watchmen", id: "360733", offset: 0, source: "HBO Nordic"},
    {name: "Our Last Crusade or the Rise of a New World", id: "387027", offset: 1, source: "BTN"},
    {name: "Animaniacs", id: "72879", offset: 1, source: "BTN"},
    {name: "James May: Oh Cook!", id: "384721", offset: 1, source: "BTN"},
    {name: "Disney Gallery: The Mandalorian", id: "380352", offset: 0, source: "Disney+"},
    {name: "Wandavision", id: "362392", offset: 0, source: "Disney+"},
    {name: "Unsolved Mysteries", id: "76644", offset: 0, source: "Disney+"},
    {name: "Legend of the Galactic Heroes: Die Neue These", id: "343237", offset: 0, source: "Crunchyroll"}
]


SCHEDULER.every "6h", :first_in => 0 do |job|
  # Authorization
  puts("TV-Series, initiate update at #{Time.now.strftime("%H:%M")}")
  puts("Attempting to fetch auth token")
  auth_uri = URI.parse(URI.encode("https://api.thetvdb.com/login"))
  http = Net::HTTP.new(auth_uri.host, auth_uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Post.new(auth_uri)
  request.add_field('Content-Type', 'application/json')
  request.add_field('Accept-Type', 'application/json')
  request.body = {'apikey' => '51F6746BE38B32BF'}.to_json
  response = http.request(request)
  responseData = JSON.parse response.body

  authentication_token = responseData["token"]
  puts("Auth token recieved: #{authentication_token}")
# Fetch episode data
  episodes = []
  series.each do |serie|

    puts("Fetching information for series: #{serie[:name]} with offset #{serie[:offset]}")
    t = Time.now
    t = t - serie[:offset]*(60*60*24)

    #url = "https://api.thetvdb.com/series/#{serie[:id]}/episodes/query?firstAired=2016-12-07"
    url = "https://api.thetvdb.com/series/#{serie[:id]}/episodes/query?firstAired=#{t.strftime "%Y-%m-%d"}"
    puts(url)
    begin
      buffer = open(url,
                    :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE,
                    "Authorization" => "Bearer #{authentication_token}").read

      json_parse = JSON.parse(buffer)


      data = json_parse["data"].first
      title = "#{serie[:name]} #{data["airedSeason"]}x#{data["airedEpisodeNumber"]}: #{data["episodeName"]}"
      puts(data)
      episodes << {title: title, episode: truncate(data["overview"]), source: serie[:source]}

    rescue OpenURI::HTTPError => e
      puts("No Data found due to #{e}")
    end
  end

  puts("Episodes found:")
  puts(episodes)

  unless episodes.any?
    puts("Setting placeholder for empty episode array")
    episodes << {title: "No episodes available today", episode: '', source: ''}
  end
  puts("Send Event")
  send_event("tvseriestoday", { :episodes => episodes})
end

  def truncate(string, length = 300)
    raise 'Truncate: Length should be greater than 3' unless length > 3

    truncated_string = string.to_s
    if truncated_string.length > length
      truncated_string = truncated_string[0...(length - 3)]
      truncated_string += '...'
    end
    truncated_string
  end
