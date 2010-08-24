class TweetsController < ApplicationController
  def index
    page = 1
    page ||= params[:page]
    @tags = Tag.all
    @tweets = {}
    @links = {}
    @tags.each do |tag|
      @tweets[tag.name] = Tweet.last_tweets_for tag, :page=> page
      @links[tag.name] = Link.most_popular_for tag
    end
  end
end
