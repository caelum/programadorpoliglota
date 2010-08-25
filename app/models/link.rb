class Link < ActiveRecord::Base
  belongs_to :tag
  
  def self.create_from (tweet)
    urls = tweet.text.scan(/http:\/\/[^\s]+/)
    urls.each do |url|
      full_url = full_url_for url
      link_found = Link.find_by_tag_id_and_url(tweet.tag.id, full_url)
      if link_found 
        link_found.quantity += 1
        link_found.save
      else
        link = Link.create :url=>full_url, :tag=>tweet.tag, :quantity => 1
        tweet.tag.links << link
      end
    end
  end

  def self.most_popular_for(tag)
      where(:tag_id=>tag.id).limit(5).order('quantity DESC, updated_at DESC')
  end
  
  private
  def self.full_url_for(tinyurl)
    LinkRecover.decode tinyurl
  end
end
