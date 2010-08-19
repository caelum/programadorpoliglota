class Link < ActiveRecord::Base
  belongs_to :tweet
  
  def self.create_from (tweet)
    urls = tweet.text.scan(/http:\/\/[^\s]+/)
    urls.each do |url|
      link = Link.create :url=>url, :tweet=>tweet
      tweet.links << link
    end
  end
end
