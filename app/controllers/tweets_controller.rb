class TweetsController < ApplicationController
  def index
    @tags = Tag.all
    @tweets = {}
    @links = {}
    @tags.each do |tag|
      @tweets[tag.name] = Tweet.joins(:tag).where(:tags=>{:name=>tag.name}).order('date DESC')
      @links[tag.name] = Link.most_popular_today_for tag
    end
  end
end
