class TweetsRetrievalJob
  def import_all_groups_tweets
    start = Time.now
    tag_groups = TagGroup.all

    tag_groups.each do |tag_group|
      import_tweets_of tag_group
    end

    Rails.logger.info "Tweets added in #{Time.now - start}"
  end

  def import_tweets_of(tag_group)
    twitter_queries = TwitterQueryBuilder.build_queries_for_group(tag_group)
    twitter_queries.each do |query|
      query.each do |tweet|
        import_raw_tweet_to_group(tweet, tag_group)
      end
    end
  end

  def import_raw_tweet_to_group(raw_tweet, tag_group)
    unless Tweet.already_exists_in_group?(raw_tweet, tag_group)
      user = User.create_user_if_not_exists raw_tweet
      new_tweet = Tweet.create :text=>raw_tweet.text, :date=>raw_tweet.created_at, :tag_group=>tag_group, :tweet_id=>raw_tweet.id
      new_tweet.user = user
      tag_group.tweets << new_tweet

      RetweetedUser.extract_retweets_from(new_tweet)
      Link.create_from(new_tweet)
      Rails.logger.debug "Tweet ##{raw_tweet.id} created for the #{tag_group.name} group"
    else
      Rails.logger.debug "Tweet ##{raw_tweet.id} already exists for the #{tag_group.name} group, therefore skipping it"
    end 
  end
end
