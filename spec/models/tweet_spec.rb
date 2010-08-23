require 'spec_helper'

describe Tweet do
  describe "#add_new_tweets" do
    it "should not add new tweets when no tags are found" do
      Tag.should_receive(:all).and_return([])
      Tweet.add_new_tweets
      Tweet.should_not_receive(:where)
    end
    
    it "should save ALL tweets when there are no tweets for a given tag" do
      tag = mock_model(Tag)
      tag.should_receive(:name).and_return('#java')
      Tag.should_receive(:all).and_return([tag])
      Link.should_receive(:create_from)
      
      query = Object.new 
      Tweet.should_receive(:where).with(:tag_id=>tag.id).and_return(query)
      query.should_receive(:order).with('date').and_return(query)
      query.should_receive(:last).and_return(nil)
      
      tweets = Hashie::Mash.new
      
      twitter_query = Object.new
      Twitter::Search.should_receive(:new).with('#java').and_return(twitter_query)
      twitter_query.should_receive(:lang).with('pt').and_return(twitter_query)
      twitter_query.should_receive(:per_page).with(100).and_return(twitter_query)
      twitter_query.should_not_receive(:since_date)
      twitter_query.should_receive(:each).and_yield(tweets)
      
      tag.should_receive(:tweets).and_return([])
      
      Tweet.add_new_tweets
    end
    
    it "should save just new tweets when there are old tweets for a given tag" do
      tag = mock_model(Tag)
      tag.should_receive(:name).and_return('#java')
      Tag.should_receive(:all).and_return([tag])
      Link.should_receive(:create_from)
      
      tweet = mock_model(Tweet)
      tweet.should_receive(:tweet_id).and_return(10)
      
      query = Object.new 
      Tweet.should_receive(:where).with(:tag_id=>tag.id).and_return(query)
      query.should_receive(:order).with('date').and_return(query)
      query.should_receive(:last).and_return(tweet)
      
      tweets = Hashie::Mash.new
      
      twitter_query = Object.new
      Twitter::Search.should_receive(:new).with('#java').and_return(twitter_query)
      twitter_query.should_receive(:lang).with('pt').and_return(twitter_query)
      twitter_query.should_receive(:per_page).with(100).and_return(twitter_query)
      twitter_query.should_receive(:since).with(10).and_return(twitter_query)
      twitter_query.should_receive(:each).and_yield(tweets)
      
      tag.should_receive(:tweets).and_return([])
      
      Tweet.add_new_tweets
    end 
  end
  
  describe '#last_tweets_for_tag' do
    it 'should return the tweets for a given tag' do
      java_tag = Tag.create :name=> '#java'
      ruby_tag = Tag.create :name=> '#ruby'
      Tweet.create :text=>'tweet 1', :tag=>java_tag
      Tweet.create :text=>'tweet 2', :tag=>ruby_tag
      
      found = Tweet.last_tweets_for java_tag
      
      found.size.should == 1
    end
    
    it 'should return the tweets ordered by date (DESC)' do
      java_tag = Tag.create :name=> '#java'
      newer_1 = Tweet.create :text=>'tweet 2', :tag=>java_tag
      newer_2 = Tweet.create :text=>'tweet 2', :tag=>java_tag
      older = Tweet.create :text=>'older', :tag=>java_tag, :created_at=>Time.now-1.day
      
      found = Tweet.last_tweets_for java_tag
      
      found[2].should == older
    end
  end
end
