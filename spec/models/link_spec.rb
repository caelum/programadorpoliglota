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
  
  describe "#most_popular_for" do
    it "should return most popular links for a given tag ordered by quantity" do
      tag = Tag.create :name=>'#java'
      non_famous_link = Link.create :url=>'http://www.example.com', :quantity=>2, :tag=>tag
      Link.create :url=>'http://www.examplewow.com', :quantity=>3, :tag=>tag
      famous_link = Link.create :url=>'http://www.anotherexample.com', :quantity=>5, :tag=>tag
      
      popular_links = Link.most_popular_for(tag)
      popular_links.first.should == famous_link
      popular_links.last == non_famous_link
    end
    
    it "should return most popular links for a given tag ordered by updated time" do
      tag = Tag.create :name=>'#java'
      older = Link.create :url=>'http://www.examplewow.com', :quantity=>3, :tag=>tag, :updated_at => Time.now-1.day
      newer = Link.create :url=>'http://www.example.com', :quantity=>3, :tag=>tag

      popular_links = Link.most_popular_for(tag)
      popular_links.first.should == newer
      popular_links.last == older
    end
  end  
end
