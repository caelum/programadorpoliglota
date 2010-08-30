class User < ActiveRecord::Base
  has_many :tweets
  has_many :retweeted_users
  
  def self.create_user_if_not_exists(tweet)
    twitter_id = tweet.from_user
    user = where(:twitter_id => twitter_id).first
    if user
      user.image_url = tweet.profile_image_url
      user.save
    else
      user = User.create :twitter_id=>twitter_id, :image_url=>tweet.profile_image_url
    end
    user
  end
end
