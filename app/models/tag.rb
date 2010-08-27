class Tag < ActiveRecord::Base
  has_many :tweets
  has_many :links
  has_many :retweeted_users
end
