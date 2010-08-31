class Community < ActiveRecord::Base
  belongs_to :tag
  
  validates_presence_of :name
  validates_format_of :url, :with => /http:\/\/[^\s]+/
end
