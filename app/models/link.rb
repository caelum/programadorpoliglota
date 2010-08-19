class Link < ActiveRecord::Base
  belongs_to :tweet
  
  def self.create_from (tweet)
    urls = tweet.text.scan(/http:\/\/[^\s]+/)
    urls.each do |url|
      link = Link.create :url=>url, :tweet=>tweet
      tweet.links << link
    end
  end
  
  def self.most_popular_today_for(tag)
      select('count(links.url) as quantity, links.url')
        .joins(:tweet => :tag)
        .where('tweets.date' => (Time.now - 1.day)..Time.now, 'tags.name' => tag.name)
        .group('links.url')
        .order('quantity desc')
  end
end
