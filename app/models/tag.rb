class Tag < ActiveRecord::Base
  has_many :tweets
end
