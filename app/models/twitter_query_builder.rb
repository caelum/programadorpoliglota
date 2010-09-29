class TwitterQueryBuilder
  def self.build_queries_for_group(tag_group)
    queries = []
    tag_group.tags.each do |tag|
      Rails.logger.debug "Accessing twitter API and searching for #{tag.name}"
      last_tweet = Tweet.last_tweet_from_group tag_group
      twitter_query = Twitter::Search.new(tag.name).lang('pt').per_page(100)
      twitter_query = twitter_query.since(last_tweet.tweet_id.to_i) if last_tweet
      queries << twitter_query
    end
    #TODO essa iteracao pode ser melhorada!
    queries
  end
end
