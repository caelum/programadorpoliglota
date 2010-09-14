require 'spec_helper'

describe RetweetedUser do
  describe '#scan_for_retweeteds' do
    it 'should find the retweeted user when there is only one RT on the message' do
      found = RetweetedUser.scan_for_retweeteds 'RT @adrianoalmeida7: this is a RT'
      
      found.size.should == 1
      found[0].should == 'adrianoalmeida7'
    end
    
    it 'should find the two retweeted users when there are two RT on the message' do
      found = RetweetedUser.scan_for_retweeteds 'RT @adrianoalmeida7: RT @lucasas: this is double a RT'
      
      found.size.should == 2
      found[0].should == 'adrianoalmeida7'
      found[1].should == 'lucasas'
    end
  end
  
  describe '#extract_retweets_from' do
    it 'should create a new retweeted user when a user who wasnt retweeted before is found will have the amount RTs set at 1' do
      user = User.create :twitter_id=>'adrianoalmeida7'
      tag = Tag.create :name=>'#java'
      tweet = Tweet.new :text=>'RT @adrianoalmeida7: a tweet', :tag=>tag
      
      RetweetedUser.extract_retweets_from tweet
      
      rt_user = RetweetedUser.first
      rt_user.user.twitter_id.should == user.twitter_id
      rt_user.tag.id.should == tag.id
      rt_user.amount.should == 1
    end
    
    it 'should increase the amount of a retweeted user when a user is found' do
      user = User.create :twitter_id=>'adrianoalmeida7'
      tag = Tag.create :name=>'#java'
      RetweetedUser.create :user=>user, :tag=>tag, :amount=>5
      tweet = Tweet.new :text=>'RT @adrianoalmeida7: a tweet', :tag=>tag
      
      RetweetedUser.extract_retweets_from tweet
      
      rt_user = RetweetedUser.first
      rt_user.user.twitter_id.should == user.twitter_id
      rt_user.amount.should == 6
    end
    
    it 'should increase the amount of a retweeted user when a user is found for the tweet tag' do
      user = User.create :twitter_id=>'adrianoalmeida7'
      java_tag = Tag.create :name=>'#java'
      ruby_tag = Tag.create :name=>'#ruby'
      RetweetedUser.create :user=>user, :tag=>java_tag, :amount=>5
      tweet = Tweet.new :text=>'RT @adrianoalmeida7: a tweet', :tag=>ruby_tag
      
      RetweetedUser.extract_retweets_from tweet
      
      rt_user = RetweetedUser.find_by_user_id_and_tag_id(user.id, ruby_tag.id)
      rt_user.amount.should == 1
    end
  end
  
  describe '#most_retweeted_for' do
    it 'should return the 10 most retweeted for the given tag' do
      tag = Tag.create :name=>'#ruby'
      15.times do
        user = User.create :twitter_id=>'Baba'
        RetweetedUser.create :tag=>tag, :user=>user, :amount=>10
      end 
      user = RetweetedUser.first
      user.amount = 50
      user.save

      result = RetweetedUser.most_retweeted_for(tag)
      
      result[0].amount.should == 50
      result.size.should == 5
    end
  end
end