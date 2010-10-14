class RetweetedUser < ActiveRecord::Base
  belongs_to :tag_group
  belongs_to :user 
  
  def self.extract_retweets_from(tweet)
    retweeteds = scan_for_retweeteds(tweet.text)
    retweeteds.each do |r|
      user = User.find_or_create_by_twitter_id(r)
      rt_user = RetweetedUser.create :tag_group_id=>tweet.tag_group.id, :user_id=>user.id
    end
  end
  
  def self.scan_for_retweeteds(text)
    text.scan(/RT[\s]+@([^:\s]+)/).collect {|v| v[0]}
  end
  
  def self.most_retweeted_for(tag_group)
    where('tag_group_id = ? and created_at > ?', tag_group.id, 7.days.ago).includes(:user).group('user_id').order('count(user_id) DESC').limit(5)
  end
end
