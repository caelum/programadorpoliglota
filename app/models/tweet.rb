class Tweet < ActiveRecord::Base
  belongs_to :tag

  def self.add_new_tweets
    tags = Tag.all
    tags.each do |tag|
      twitter_query = build_twitter_query_for(tag)
      create_new_tweets_from_query(twitter_query, tag)
    end
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
      new_tweet = Tweet.new
      new_tweet.user = tweet.from_user
      new_tweet.text = tweet.text
      new_tweet.date = tweet.created_at
      new_tweet.image_url = tweet.profile_image_url
      new_tweet.tag = tag
      new_tweet.tweet_id = tweet.id
      new_tweet.save
      tag.tweets << new_tweet
    end
  end
  
end
