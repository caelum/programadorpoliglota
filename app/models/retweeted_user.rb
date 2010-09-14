class RetweetedUser < ActiveRecord::Base
  belongs_to :tag
  belongs_to :user 
  
  def self.extract_retweets_from(tweet)
    retweeteds = scan_for_retweeteds(tweet.text)
    retweeteds.each do |r|
      user = User.find_or_create_by_twitter_id(r)
      rt_user = find_or_create_by_tag_id_and_user_id(tweet.tag.id, user.id)
      rt_user.amount = rt_user.amount ? rt_user.amount + 1 : 1
      rt_user.save
    end
  end
  
  def self.scan_for_retweeteds(text)
    text.scan(/RT[\s]+@([^:\s]+)/).collect {|v| v[0]}
  end
  
  def self.most_retweeted_for(tag)
    where(:tag_id => tag.id).includes(:user).order('amount DESC').limit(5)
  end
end
