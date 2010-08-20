require 'spec_helper'

describe Link do
  describe "#extract_from" do
    it "should extract all links for a given tweet" do
      tag_java = Tag.new :name=>"#java"
      tweet = Tweet.new :text=>"Esse eh um teste com http://www.caelum.com.br e http://blog.caelum.com.br #java"
      tweet.tag = tag_java
      
      Link.should_receive(:create).with(:url=>'http://www.caelum.com.br', :tag=>tag_java, :quantity => 1).and_return(Link.new)
      Link.should_receive(:create).with(:url=>'http://blog.caelum.com.br', :tag=>tag_java, :quantity => 1).and_return(Link.new)
      Link.should_receive(:find_by_tag_id_and_url).twice.and_return(nil)
          
      Link.create_from tweet
    end
    
    
    it "should update the quantity if the link already exists" do
      tag_java = Tag.new :name=>"#java"
      tweet = Tweet.new :text=>"Esse eh um teste com http://www.caelum.com.br #java"
      tweet.tag = tag_java
      
      link = Link.new :quantity => 1, :url => "http://www.caelum.com.br"
      link.should_receive(:save)
      Link.should_receive(:find_by_tag_id_and_url).and_return(link)

      Link.create_from tweet
      
      link.quantity.should == 2
    end
    
    it "should ignore link when it is just http:// (incomplete)" do
      Link.should_not_receive(:create)
      
      tweet = Tweet.new :text=>"Esse eh um teste http:// com link incompleto"
      links = Link.create_from tweet
      
    end
  end
  
  describe "#most_popular_today_from" do
    it "should return most popular links today for a given tag" do
      pending
    end
  end  
end
