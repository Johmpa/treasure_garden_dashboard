require 'rss'
require 'open-uri'
require 'nokogiri'
require 'htmlentities'

news_feeds = {
    #"bbc-tech" => "http://feeds.bbci.co.uk/news/technology/rss.xml",
    #"mashable" => "http://feeds.feedburner.com/Mashable",
    #"techcrunch" => "http://feeds.feedburner.com/TechCrunch/",
    #"opm" => "http://www.opm.gov/rss/operatingstatus.atom",
    #"dn" => "http://www.dn.se/nyheter/m/rss/",
    #"sweclockers" => "http://www.sweclockers.com/feeds/nyheter",
    #"svt" => "https://www.svt.se/nyheter/rss.xml",
    "svd" => "https://www.svd.se/?service=rss",
}

Decoder = HTMLEntities.new

class News
  def initialize(widget_id, feed)
    @widget_id = widget_id
    @feed = feed
  end

  def widget_id()
    @widget_id
  end

  def truncate(string, length = 200)
    raise 'Truncate: Length should be greater than 3' unless length > 3

    truncated_string = string.to_s
    if truncated_string.length > length
      truncated_string = truncated_string[0...(length - 3)]
      truncated_string += '...'
    end
    truncated_string
  end

  def latest_headlines()
    news_headlines = []
    open(@feed, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each do |item|
        title = clean_html(item.title.to_s)
        begin
          summary = truncate(clean_html(item.description))
        rescue
          doc = Nokogiri::HTML(item.summary.content)
          summary = truncate((doc.xpath("//text()").remove).to_s)
        end
        news_headlines.push({title: title, description: summary})
      end
    end
    news_headlines
  end

  def clean_html(html)
    html = html.gsub(/<\/?[^>]*>/, "")
    html = Decoder.decode(html)
    return html
  end

end

@News = []
news_feeds.each do |widget_id, feed|
  begin
    @News.push(News.new(widget_id, feed))
  rescue Exception => e
    puts e.to_s
  end
end

SCHEDULER.every '60m', :first_in => 0 do |job|
  @News.each do |news|
    headlines = news.latest_headlines()
    send_event(news.widget_id, {:headlines => headlines})
  end
end