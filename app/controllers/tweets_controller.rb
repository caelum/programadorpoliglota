class TweetsController < ApplicationController
  def index
    @tweets = Tweet.joins(:tag).where(:tags=>{:name=>'#java'})
  end
end
