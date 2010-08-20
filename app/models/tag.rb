class Tag < ActiveRecord::Base
  has_many :tweets
  has_many :links
end
