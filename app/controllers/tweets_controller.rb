class TweetsController < ApplicationController
  def index
    page = 1
    @tags = Tag.all
    @tweets = {}
    @links = {}    
    @retweeted_users = {}
    load_tweets_and_links_for @tags, page
  end
  
  def see_more
    @page = params[:page].to_i ||= 1
    @tag = Tag.find(params[:tag].to_i)
    @tweets = retrieve_tweets_for @tag, @page    
    has_more_pages(@tag)
    
    render :layout => false
  end
  
  private
  
  def has_more_pages(tag)
    total_tweets = Tweet.amount_of_tweets_for @tag
    @has_more_pages = (total_tweets > @page * Tweet::TWEETS_PER_PAGE)  
  end
  
  def load_tweets_and_links_for(tags, page)
    tags.each do |tag|
      @tweets[tag.name] = retrieve_tweets_for tag, page
      @retweeted_users[tag.name] = RetweetedUser.most_retweeted_for(tag)
      @links[tag.name] = Link.most_popular_for tag
    end
  end  
  
  def retrieve_tweets_for(tag, page)
    Tweet.last_tweets_for tag, :page=> page
  end  
end
