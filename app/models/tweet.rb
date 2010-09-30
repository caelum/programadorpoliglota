class Tweet < ActiveRecord::Base
  belongs_to :tag_group
  belongs_to :user
  TWEETS_PER_PAGE = 4

  def self.last_tweets_for(tag_group, hash={})
    options = {:page=>1}
    options.merge! hash
    offset = (options[:page] - 1) * TWEETS_PER_PAGE
    joins(:tag_group).where(:tag_groups=>{:name=>tag_group.name}).includes(:user).limit(TWEETS_PER_PAGE).offset(offset).order('date DESC')
  end

  def self.amount_of_tweets_for(tag_group)
    where(:tag_group_id=>tag_group.id).count
  end

  def self.last_tweet_from_group(tag_group) 
    where(:tag_group_id=>tag_group.id).order('date').last
  end

  def self.already_exists_in_group?(raw_tweet, tag_group)
    where(:tweet_id=>raw_tweet.id, :tag_group_id=>tag_group.id).exists?
  end
end