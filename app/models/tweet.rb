class Tweet < ActiveRecord::Base
  belongs_to :tag
  belongs_to :user
  TWEETS_PER_PAGE = 4

  def self.add_new_tweets
    tags = Tag.all
    tags.each do |tag|
      twitter_query = build_twitter_query_for(tag)
      create_new_tweets_from_query(twitter_query, tag)
    end
  end
  
  def self.last_tweets_for(tag, hash={})
    options = {:page=>1}
    options.merge! hash
    offset = (options[:page] - 1) * TWEETS_PER_PAGE
    joins(:tag).where(:tags=>{:name=>tag.name}).includes(:user).limit(TWEETS_PER_PAGE).offset(offset).order('date DESC')
  end
  
  def self.amount_of_tweets_for(tag)
    where(:tag_id=>tag.id).size
  end
  
  private

  def self.build_twitter_query_for(tag)
    last_tweet = Tweet.where(:tag_id=>tag.id).order('date').last
    twitter_query = Twitter::Search.new(tag.name).lang('pt').per_page(100)
    twitter_query = twitter_query.since(last_tweet.tweet_id.to_i) if last_tweet
    
    twitter_query
  end
  
  def self.create_new_tweets_from_query(twitter_query, tag)
    twitter_query.each do |tweet|
      user = User.create_user_if_not_exists tweet
      
      new_tweet = Tweet.create :user=> user, :text=>tweet.text, :date=>tweet.created_at, :tag=> tag, :tweet_id=>tweet.id
      tag.tweets << new_tweet
      RetweetedUser.extract_retweets_from(new_tweet)
      Link.create_from(new_tweet)
    end
  end  
end