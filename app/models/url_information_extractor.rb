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
  
  def title
    begin
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.get(@url).title
    rescue Exception => e
      logger   = Logger.new('links.log')
      logger.error "Problems extracting title: #{e}. Will use the full url as the title"
      @url
    end
  end
end