class Link < ActiveRecord::Base
  belongs_to :tag_group
  
  def self.create_from (tweet)
    urls = scan_for_urls(tweet.text)
    logger.debug "Found #{urls.size} urls for the tweet: #{tweet.id}"
    urls.each do |url|
        extractor = URLInformationExtractor.new url
        logger.debug "The url at the tweet is: #{url} ... preparing to unwrap it"
        
        full_url = extractor.unwrap
        logger.debug "The full url found is: #{full_url}"
        title = extractor.title
        logger.debug "The title of url found is: #{title}"
        
        link = Link.create :url=>full_url, :tag_group=>tweet.tag_group, :title=>title
        tweet.tag_group.links << link
    end
  end
  
  def self.most_popular_for(tag_group)
      Link.select("count(*) as quantidade, url, title").where(["created_at > ? AND tag_group_id = ?", 7.days.ago, tag_group.id]).group("url").order("quantidade desc").all
  end

  def self.scan_for_urls(text)
    text.scan(/http[s]?:\/\/+[\w\d:\#\@\%\/;\$\(\)\~\_\?\+\-\=\\\.&]+/)
  end  
end


