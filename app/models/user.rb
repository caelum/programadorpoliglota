class User < ActiveRecord::Base
  has_many :tweets
  has_many :retweeted_users
  
  def self.create_user_if_not_exists(tweet)
    User.find_or_create_by_twitter_id_and_image_url(tweet.from_user, tweet.profile_image_url)
  end
  
end
