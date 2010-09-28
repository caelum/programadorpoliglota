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
        link_found = Link.find_by_tag_group_id_and_url(tweet.tag_group.id, full_url)
        if link_found
          link_found.quantity += 1
          logger.debug "Link already found. So, just incrementing the quantity to #{link_found.quantity}"
          link_found.save
        else
          logger.debug "Link not found. So, creating it"
          title = extract_title(extractor, full_url)
          link = Link.create :url=>full_url, :tag_group=>tweet.tag_group, :quantity => 1, :title=>title
          tweet.tag_group.links << link
        end
    end
  end

  def self.extract_title(extractor, full_url)
     begin
       extractor.title
     rescue Exception => e
       logger.error "Problems extracting title: #{e}. Will use the full url as the title"
       full_url
     end
  end

  def self.most_popular_for(tag)
      where(:tag_group_id=>tag.id).limit(3).order('quantity DESC, updated_at DESC')
  end

  def self.scan_for_urls(text)
    text.scan(/http[s]?:\/\/+[\w\d:\#\@\%\/;\$\(\)\~\_\?\+\-\=\\\.&]+/)
  end  
end
