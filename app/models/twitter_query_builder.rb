class TwitterQueryBuilder
  def self.build_queries_for_group(tag_group)
    tag_group.tags.collect do |tag|
      Rails.logger.debug "Accessing twitter API and searching for #{tag.name}"
      last_tweet = Tweet.last_tweet_from_group tag_group
      twitter_query = Twitter::Search.new(tag.query).lang('pt').per_page(100)
      twitter_query = twitter_query.since(last_tweet.tweet_id.to_i) if last_tweet
      twitter_query
    end
  end
end
