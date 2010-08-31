require 'spec_helper'

describe TweetHelper do
  describe '#next_page_link' do
    it 'should return the next page link' do
      helper.next_page_link(5, 3).should == '<a href="http://test.host/tweets/see_more/3/6" class="ver_mais">Ver mais</a>'
    end
  end
  
  describe '#previous_page_link' do
    it 'should return the previous page link' do
      helper.previous_page_link(5, 3).should == '<a href="http://test.host/tweets/see_more/3/4" class="ver_mais">Anteriores</a>'
    end
  end
  
  describe '#image_url_of' do
    it 'should return the image url of the given user when it has one' do
      user = User.new :image_url => 'url'
      helper.image_url_of(user).should == 'url'
    end
    
    it 'should return the default image url of the given user when does not have one' do
      user = User.new
      helper.image_url_of(user).should == '/images/default_twitter.png'
    end
  end
end
