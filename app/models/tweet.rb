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

  def self.create_tweets_from_queries(twitter_queries, tag_group)
    logger.info "Creating tweets for the tag group #{tag_group.name}"
    twitter_queries.each do |query|
      query.each do |tweet|
        logger.debug "Trying to add the tweet ##{tweet.id}"
        create_if_doesnt_exist_in_tag_group tweet, tag_group
      end
    end
  end 

  def self.create_if_doesnt_exist_in_tag_group(tweet, tag_group)
    if !where(:tweet_id => tweet.id, :tag_group_id => tag_group.id).exists?
      user = User.create_user_if_not_exists tweet
      new_tweet = Tweet.create :user=> user, :text=>tweet.text, :date=>tweet.created_at, :tag_group=> tag_group, :tweet_id=>tweet.id
      tag_group.tweets << new_tweet
      RetweetedUser.extract_retweets_from(new_tweet)
      Link.create_from(new_tweet)
      logger.debug "Tweet ##{tweet.id} created for the #{tag_group.name} group"
    else
      logger.debug "Tweet ##{tweet.id} already exists for the #{tag_group.name} group, therefore skipping it"
    end  
  end
  
  def self.last_tweet_from_group(a_group) 
    Tweet.where(:tag_group_id=>a_group.id).order('date').last
  end
end