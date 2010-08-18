require 'spec_helper'

describe TweetsController do
  describe "#index" do
    it "should retrive all tweets for #java Tag" do
      tweets = [Tweet.new, Tweet.new]
      join = Object.new
      Tweet.should_receive(:joins).with(:tag).and_return(join) 
      join.should_receive(:where).with(:tags=>{:name=>'#java'}).and_return(tweets)
      
      get :index
      assigns(:tweets).should eq(tweets)
    end
  end
end
