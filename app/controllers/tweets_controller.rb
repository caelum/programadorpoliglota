class TweetsController < ApplicationController
  def index
    page = 1
    @tags = Tag.all
    @tweets = {}
    @links = {}    
    load_tweets_and_links_for @tags, page
  end
  
  def see_more
    page = params[:page].to_i ||= 1
    @tag = Tag.find(params[:tag].to_i)
    @tweets = retrieve_tweets_for @tag, page
    @page = page + 1    

    render :layout => false
  end
  
  private
  def load_tweets_and_links_for(tags, page)
    tags.each do |tag|
      @tweets[tag.name] = retrieve_tweets_for tag, page
      @links[tag.name] = Link.most_popular_for tag
    end
  end  
  
  def retrieve_tweets_for tag, page
    Tweet.last_tweets_for tag, :page=> page
  end
end
