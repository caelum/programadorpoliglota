class Link < ActiveRecord::Base
  belongs_to :tag
  
  def self.create_from (tweet)
    urls = tweet.text.scan(/http:\/\/[^\s]+/)
    urls.each do |url|
      link_found = Link.find_by_tag_id_and_url(tweet.tag.id, url)
      if link_found 
        link_found.quantity += 1
        link_found.save
      else
        link = Link.create :url=>url, :tag=>tweet.tag, :quantity => 1
        tweet.tag.links << link
      end
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
