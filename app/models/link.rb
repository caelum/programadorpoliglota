class Link < ActiveRecord::Base
  belongs_to :tag_group
  
  def self.create_from (tweet)
    urls = scan_for_urls(tweet.text)
    urls.each do |url|
      extractor = URLInformationExtractor.new url
      full_url = extractor.unwrap
      link_found = Link.find_by_tag_group_id_and_url(tweet.tag_group.id, full_url)
      if link_found 
        link_found.quantity += 1
        link_found.save
      else
        link = Link.create :url=>full_url, :tag_group=>tweet.tag_group, :quantity => 1, :title=>extractor.title
        tweet.tag_group.links << link
      end
    end
  end

  def self.most_popular_for(tag)
      where(:tag_group_id=>tag.id).limit(1).order('quantity DESC, updated_at DESC')
  end

  def self.scan_for_urls(text)
    text.scan(/http[s]?:\/\/+[\w\d:\#\@\%\/;\$\(\)\~\_\?\+\-\=\\\.&]+/)
  end  
end
