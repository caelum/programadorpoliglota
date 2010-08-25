class URLInformationExtractor
  def initialize(url)
    @url = url
  end
  
  def unwrap
    location = Net::HTTP.get_response(URI.parse(@url)).to_hash['location']
    location == nil ? @url : location[0]
  end
  
  def title
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    agent.get(@url).title
  end
end