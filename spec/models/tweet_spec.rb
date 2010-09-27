require 'spec_helper'

describe Tweet do
  describe "#add_new_tweets" do
    it "should not add new tweets when no tag group is found" do
      TagGroup.should_receive(:all).and_return([])
      Tweet.add_new_tweets
      Tweet.should_not_receive(:where)
    end

    it "should build twitter query and create new tweets from it for all existent tag groups" do
      group = TagGroup.new :name=>'Ruby'
      query = Object.new
      TagGroup.should_receive(:all).and_return([group])
      Tweet.should_receive(:build_twitter_query_for).with(group).and_return(query)
      Tweet.should_receive(:create_new_tweets_from_query).with(query, group)

      Tweet.add_new_tweets
    end
  end  
  
  describe '#last_tweets_for_tag' do
    it 'should return the tweets for a given tag' do
      java_tag_group = TagGroup.create :name=> '#java'
      ruby_tag_group = TagGroup.create :name=> '#ruby'
      Tweet.create :text=>'tweet 1', :tag_group=>java_tag_group
      Tweet.create :text=>'tweet 2', :tag_group=>ruby_tag_group
      
      found = Tweet.last_tweets_for java_tag_group
      
      found.size.should == 1
    end
    
    it 'should return the tweets ordered by date (DESC)' do
      java_tag_group = TagGroup.create :name=> '#java'
      newer_1 = Tweet.create :text=>'tweet 2', :tag_group=>java_tag_group, :date=>Time.now
      older = Tweet.create :text=>'older', :tag_group=>java_tag_group, :date=>Time.now-1.day
      newer_2 = Tweet.create :text=>'tweet 2', :tag_group=>java_tag_group, :date=>Time.now

      found = Tweet.last_tweets_for java_tag_group
      found[2].should == older
    end
    
    it 'should return the tweets paginated' do
      java_tag_group = TagGroup.create :name=> '#java'
      
      15.times do 
        Tweet.create :text=>'tweet 2', :tag_group=>java_tag_group, :date=>Time.now
      end
      
      found = Tweet.last_tweets_for(java_tag_group, :page=>2)

      found[0].tag_group.name.should == java_tag_group.name
      found.size.should == 4
    end
  end
  
  describe "#amount_of_tweets_for" do
    it "should return 15 when 15 tweets are created for a given tag" do
      java_tag_group = TagGroup.create :name=> '#java'
      15.times do 
        Tweet.create :text=>'tweet 2', :tag_group=>java_tag_group, :date=>Time.now
      end
      
      amount = Tweet.amount_of_tweets_for(java_tag_group)
      
      amount.should == 15
    end
  end
  
  describe "#create_if_doesnt_exist_in_tag_group" do
    it "should create a new tweet if it does not exist in the tag group" do
      java_tag_group = TagGroup.create :name=> '#java'
      
      user = User.create :twitter_id => '@lucasas', :image_url => 'foto.png'
      User.should_receive(:create_user_if_not_exists).and_return(user)
      
      tweet_of_twitter = Object.new
      tweet_of_twitter.should_receive(:text).and_return('Um tweet')
      tweet_of_twitter.should_receive(:created_at).and_return(Time.now)
      tweet_of_twitter.should_receive(:id).at_least(:twice).and_return('123456')
      
      Tweet.create_if_doesnt_exist_in_tag_group tweet_of_twitter, java_tag_group
      Tweet.all.size.should == 1
    end 
    
    it "should not create a new tweet if it exists in the tag group" do
      java_tag_group = TagGroup.create :name=> '#java'
      user = User.create :twitter_id => '@lucasas', :image_url => 'foto.png'
      tweet = Tweet.create :user=> user, :text=>'Um tweet', :date=>Time.now, :tag_group=> java_tag_group, :tweet_id=>'123456'
      
      tweet_of_twitter = Object.new
      tweet_of_twitter.should_receive(:id).at_least(:once).and_return('123456')
      
      Tweet.stub_chain(:where, :exists?).and_return(true)
      Tweet.create_if_doesnt_exist_in_tag_group tweet_of_twitter, java_tag_group
      
      Tweet.all.last.should == tweet
      Tweet.all.size.should == 1
    end 
    
    it "should create a new tweet if it exists in any tag group unless in the expected tag group" do
      java_tag_group = TagGroup.create :name=> '#java'
      ruby_tag_group = TagGroup.create :name=> '#ruby'
      
      user = User.create :twitter_id => '@lucasas', :image_url => 'foto.png'
      User.should_receive(:create_user_if_not_exists).and_return(user)
      
      Tweet.create :user=> user, :text=>'Um tweet', :date=>Time.now, :tag_group=> ruby_tag_group, :tweet_id=>'123456'
      
      tweet_of_twitter = Object.new
      tweet_of_twitter.should_receive(:text).and_return('Um tweet')
      tweet_of_twitter.should_receive(:created_at).and_return(Time.now)
      tweet_of_twitter.should_receive(:id).at_least(:twice).and_return('123456')
      
      Tweet.stub_chain(:where, :exists?).and_return(false)
      Tweet.create_if_doesnt_exist_in_tag_group tweet_of_twitter, java_tag_group
    
      Tweet.all.size.should == 2
    end
  end 

  describe "build_twitter_query_for" do
    it "should return the tweets from twitter api for the tags of a given tag group" do
      
    end
    end
  end
  end
end
