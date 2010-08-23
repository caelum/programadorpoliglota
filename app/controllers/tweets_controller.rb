class TweetsController < ApplicationController
  def index
    @tags = Tag.all
    @tweets = {}
    @links = {}
    @tags.each do |tag|
      @tweets[tag.name] = Tweet.last_tweets_for tag
      @links[tag.name] = Link.most_popular_for tag
    end
  end
end
