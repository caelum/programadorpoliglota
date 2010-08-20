require 'spec_helper'

describe TweetsController do
  describe "#index" do
    it "should retrive all tweets for #java Tag" do
      tweets = [Tweet.new, Tweet.new]
      tags = [Tag.new(:name=>'#java')]
      
      Tag.should_receive(:all).and_return(tags)
      query = Object.new
      Tweet.should_receive(:joins).with(:tag).and_return(query) 
      query.should_receive(:where).with(:tags=>{:name=>'#java'}).and_return(query)
      query.should_receive(:order).with('date DESC').and_return(tweets)
      
      get :index
      tweets_found = assigns(:tweets)
      tweets_found['#java'].should eq(tweets)
    end
  end
end
