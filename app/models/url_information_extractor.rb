require 'logger'

class URLInformationExtractor
  def initialize(url)
    @url = url
  end
  
  def unwrap
    begin
      location = Net::HTTP.get_response(URI.parse(@url)).to_hash['location']
      location == nil ? @url : location[0]
    rescue
      @url
    end
  end
  
  def title(default_title = nil)
    begin
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.get(@url).title
    rescue Exception => e
      logger = Logger.new('log/links.log')
      title = default_title || @url
      logger.error "Problems extracting title: #{e}. Will use #{title} as the title"
      title
    end
  end
end