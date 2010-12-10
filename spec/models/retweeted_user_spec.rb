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
    it 'should create a new retweeted user when a user who wasnt retweeted before is found' do
      user = User.create :twitter_id=>'adrianoalmeida7'
      tag = TagGroup.create :name=>'#java'
      tweet = Tweet.new :text=>'RT @adrianoalmeida7: a tweet', :tag_group=>tag
      
      RetweetedUser.extract_retweets_from tweet
      
      RetweetedUser.count.should == 1
    end
    
    it 'should create another retweeted user when one was previously created' do
      user = User.create :twitter_id=>'adrianoalmeida7'
      tag = TagGroup.create :name=>'#java'
      RetweetedUser.create :user=>user, :tag_group=>tag
      tweet = Tweet.new :text=>'RT @adrianoalmeida7: a tweet', :tag_group=>tag
      
      RetweetedUser.extract_retweets_from tweet
      
      RetweetedUser.count.should == 2
    end
    
    it 'should create new retweeted user for different tag groups' do
      user = User.create :twitter_id=>'adrianoalmeida7'
      java_tag = TagGroup.create :name=>'#java'
      ruby_tag = TagGroup.create :name=>'#ruby'
      RetweetedUser.create :user=>user, :tag_group=>java_tag
      tweet = Tweet.new :text=>'RT @adrianoalmeida7: a tweet', :tag_group=>ruby_tag
      
      RetweetedUser.extract_retweets_from tweet
      
      ruby_rts = RetweetedUser.find_all_by_user_id_and_tag_group_id(user.id, ruby_tag.id)
      ruby_rts.size.should == 1
      
      java_rts = RetweetedUser.find_all_by_user_id_and_tag_group_id(user.id, java_tag.id)
      java_rts.size.should == 1

    end
  end
  
  describe '#most_retweeted_for' do 
    it 'should return only 5 retweeteds within the last 7 days' do 
      group = TagGroup.create :name=>'#ruby'
      (1..10).each do |i|
        user_in_range = User.create :twitter_id=>"Baba#{i}"
        RetweetedUser.create :user=>user_in_range, :tag_group=>group, :created_at => 2.days.ago
      end
      user_out_range = User.create :twitter_id=>'Lili'
      RetweetedUser.create :user=>user_out_range, :tag_group=>group, :created_at => 8.days.ago

      retweeteds = RetweetedUser.most_retweeted_for(group)
      retweeteds.should_not =~ user_out_range
      retweeteds[4].user.twitter_id.should == 'Baba1' #esta falhando aki! está chegando baba4
      retweeteds.size.should == 5
    end

    it 'should return the 5 most retweeted users ordered by the amount of RTs' do
      group = TagGroup.create :name=>'#ruby'
      (1..5).each do |i|
        user_in_range = User.create :twitter_id=>"Baba#{i}"
        i.times do 
          RetweetedUser.create :user=>user_in_range, :tag_group=>group, :created_at => 2.days.ago
        end
      end

      retweeteds = RetweetedUser.most_retweeted_for(group)
      retweeteds[0].user.twitter_id == 'Baba5'
      retweeteds[4].user.twitter_id == 'Baba1'
    end
  end
end
