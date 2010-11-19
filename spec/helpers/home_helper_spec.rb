require 'spec_helper'

describe HomeHelper do
  describe '#next_page_link' do
    it 'should return the next page link' do
      helper.next_page_link(5, 3).should == '<a href="http://test.host/tweets/see_more/3/6" class="ver_mais btnMoreTweets">Ver mais</a>'
    end
  end
  
  describe '#previous_page_link' do
    it 'should return the previous page link' do
      helper.previous_page_link(5, 3).should == '<a href="http://test.host/tweets/see_more/3/4" class="ver_mais btnMoreTweets">Anteriores</a>'
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
  
  describe '#replace_text_links_for_clickable_links' do
    it 'should return the text links as clickable links' do
      text = 'Esse eh um tweet com link clicavel: http://www.caelum.com.br'
      textWithClickacleLinks = "Esse eh um tweet com link clicavel: <a href='http://www.caelum.com.br' target='_blank'>http://www.caelum.com.br</a>"
      
      helper.replace_text_links_for_clickable_links(text).should == textWithClickacleLinks
    end
  end  
end
