require 'spec_helper'

describe User do
  describe "#create_user_if_exists" do
    it "should return a new user if not exists a user with a given twitter id" do
      twitter_id = '321313321'
      profile_image_url = 'url'
      
      tweet = Object.new
      tweet.should_receive(:from_user).and_return(twitter_id)
      tweet.should_receive(:profile_image_url).and_return(profile_image_url)
      
      
      user = User.create_user_if_not_exists tweet
      user.twitter_id.should == twitter_id
    end
    
    it "should return an existing user if exists a user with a given twitter id in the database" do
      twitter_id = '321313321'
      profile_image_url = 'url'
      User.create :twitter_id=>twitter_id, :image_url=>profile_image_url
      
      
      tweet = Object.new
      tweet.should_receive(:from_user).and_return(twitter_id)
      tweet.should_receive(:profile_image_url).and_return(profile_image_url)
      
      user = User.create_user_if_not_exists tweet
      user.twitter_id.should == twitter_id
    end    
  end  
end
