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
    
    it "should retrieve all links for #java Tag" do
      java_tag = Tag.new(:name=>'#java')
      tags = [java_tag]
      links = [Link.new, Link.new]
      
      Tag.should_receive(:all).and_return(tags)
      Link.should_receive(:most_popular_today_for).with(java_tag).and_return(links)
      
      get :index
      links_found = assigns(:links)
      links_found['#java'].should eq(links)
    end
  end
end
