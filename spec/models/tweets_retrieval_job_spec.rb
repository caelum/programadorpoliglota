require 'spec_helper'

describe TweetsRetrievalJob do
  describe '#import_all_groups_tweets' do
    it "should not add new tweets when no tag group is found" do
      job = TweetsRetrievalJob.new
      job.should_not_receive(:import_tweets_of)
      job.import_all_groups_tweets
    end

    it 'should import tweets of each tag group registered' do
      TagGroup.create :name=>'Ruby'
      TagGroup.create :name=>'Java'

      job = TweetsRetrievalJob.new
      job.should_receive(:import_tweets_of).twice

      job.import_all_groups_tweets
    end
  end

  describe '#import_tweets_of' do
    it 'should ask for a query of a tag group and create new tweet from it' do
      group = TagGroup.new :name=>'Ruby'
      tweet = Object.new
      queries = [[tweet]]
      TwitterQueryBuilder.should_receive(:build_queries_for_group).with(group).and_return(queries)
      job = TweetsRetrievalJob.new
      job.should_receive(:import_raw_tweet_to_group).with(tweet,group)
      job.import_tweets_of(group)
    end
  end

  describe '#import_raw_tweet_to_group' do
    it "should create a new tweet if it does not exist in the tag group" do
      java_tag_group = TagGroup.create :name=> '#java'
      
      user = User.create :twitter_id => '@lucasas', :image_url => 'foto.png'
      User.should_receive(:create_user_if_not_exists).and_return(user)
      
      raw_tweet = Object.new
      raw_tweet.should_receive(:text).and_return('Um tweet')
      raw_tweet.should_receive(:created_at).and_return(Time.now)
      raw_tweet.should_receive(:id).at_least(:twice).and_return('123456')
      
      Tweet.should_receive(:already_exists_in_group?).with(raw_tweet, java_tag_group).and_return(false)

      TweetsRetrievalJob.new.import_raw_tweet_to_group raw_tweet, java_tag_group
      Tweet.all.size.should == 1
    end 
    
    it "should not create a new tweet if it exists in the tag group" do
      java_tag_group = TagGroup.create :name=> '#java'
      user = User.create :twitter_id => '@lucasas', :image_url => 'foto.png'
      tweet = Tweet.create :user=> user, :text=>'Um tweet', :date=>Time.now, :tag_group=> java_tag_group, :tweet_id=>'123456'
      
      raw_tweet = Object.new
      raw_tweet.should_receive(:id).at_least(:once).and_return('123456')
      
      Tweet.stub_chain(:where, :exists?).and_return(true)
      TweetsRetrievalJob.new.import_raw_tweet_to_group raw_tweet, java_tag_group
      
      Tweet.all.last.should == tweet
      Tweet.all.size.should == 1
    end 
    
    it "should create a new tweet if it exists in any tag group unless in the expected tag group" do
      java_tag_group = TagGroup.create :name=> '#java'
      ruby_tag_group = TagGroup.create :name=> '#ruby'
      
      user = User.create :twitter_id => '@lucasas', :image_url => 'foto.png'
      User.should_receive(:create_user_if_not_exists).and_return(user)
      
      Tweet.create :user=> user, :text=>'Um tweet', :date=>Time.now, :tag_group=> ruby_tag_group, :tweet_id=>'123456'
      
      raw_tweet = Object.new
      raw_tweet.should_receive(:text).and_return('Um tweet')
      raw_tweet.should_receive(:created_at).and_return(Time.now)
      raw_tweet.should_receive(:id).at_least(:twice).and_return('123456')
      
      Tweet.stub_chain(:where, :exists?).and_return(false)
      TweetsRetrievalJob.new.import_raw_tweet_to_group raw_tweet, java_tag_group
    
      Tweet.all.size.should == 2
    end
  end
end
