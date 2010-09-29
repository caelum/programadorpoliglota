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
    Tweet.create_tweets_from_queries(twitter_queries, tag_group)
  end
end
