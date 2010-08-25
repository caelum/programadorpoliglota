class LinkRecover
  
  def self.decode(tinyurl)
    location = Net::HTTP.get_response(URI.parse(tinyurl)).to_hash['location']
    location == nil ? tinyurl : location[0]
  end
  
end