class ChangeTextLinksOfTweetsForClickableLinks < ActiveRecord::Migration
  def self.up
    Tweet.all.each do |tweet|
      tweet.text = tweet.text.sub(/http[s]?:\/\/+[\w\d:\#\@\%\/;\$\(\)\~\_\?\+\-\=\\\.&]+/) { |link| "<a href='#{link}' target='_blank'>#{link}</a>" }
      tweet.save
    end  
  end

  def self.down
  end
end
