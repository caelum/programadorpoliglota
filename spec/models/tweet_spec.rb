require 'spec_helper'

describe Tweet do
 
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

  describe 'last_tweet_from_group' do
    it 'should retrieve the last tweet for the group' do
      group = TagGroup.create(:name=>'A Group')
      Tweet.create(:text=>'last', :date=>Time.now, :tag_group=>group)
      Tweet.create(:text=>'first', :date=>Time.now - 5.seconds, :tag_group=>group)

      tweet = Tweet.last_tweet_from_group group
      tweet.text.should == 'last'
    end
  end
end
