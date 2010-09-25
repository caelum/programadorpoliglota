class Tweet < ActiveRecord::Base
  belongs_to :tag_group
  belongs_to :user
  TWEETS_PER_PAGE = 4

  def self.add_new_tweets
    tag_groups = TagGroup.all
    tag_groups.each do |tag_group|
      twitter_queries = build_twitter_query_for(tag_group)
      create_new_tweets_from_query(twitter_queries, tag_group) 
    end
  end
  
  def self.last_tweets_for(tag_group, hash={})
    options = {:page=>1}
    options.merge! hash
    offset = (options[:page] - 1) * TWEETS_PER_PAGE
    joins(:tag_group).where(:tag_groups=>{:name=>tag_group.name}).includes(:user).limit(TWEETS_PER_PAGE).offset(offset).order('date DESC')
  end
  
  def self.amount_of_tweets_for(tag_group)
    where(:tag_group_id=>tag_group.id).size
  end
  
  def self.create_if_doesnt_exist_in_tag_group(tweet, tag_group)
    if !where(:tweet_id => tweet.id, :tag_group_id => tag_group.id).exists?
      user = User.create_user_if_not_exists tweet
      new_tweet = Tweet.create :user=> user, :text=>tweet.text, :date=>tweet.created_at, :tag_group=> tag_group, :tweet_id=>tweet.id
      tag_group.tweets << new_tweet
      RetweetedUser.extract_retweets_from(new_tweet)
      Link.create_from(new_tweet)
    end  
  end
  
  private

  def self.build_twitter_query_for(tag_group)
    tweets = []
    tag_group.tags.each do |tag|
      last_tweet = Tweet.where(:tag_group_id=>tag.tag_group.id).order('date').last
      twitter_query = Twitter::Search.new(tag.name).lang('pt').per_page(100)
      twitter_query = twitter_query.since(last_tweet.tweet_id.to_i) if last_tweet
      tweets << twitter_query
    end
    tweets
  end
  
  def self.create_new_tweets_from_query(twitter_queries, tag_group)
    twitter_queries.each do |twitter_query|
      twitter_query.each do |tweet|
        create_if_doesnt_exist_in_tag_group tweet, tag_group
      end
    end
  end  
end