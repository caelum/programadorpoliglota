require 'spec_helper'

describe Link do
  describe "#extract_from" do
    it "should extract all links for a given tweet" do
      Link.should_receive(:create).and_return(Link.new)
      Link.should_receive(:create).and_return(Link.new)
      
      tweet = Tweet.new :text=>"Esse eh um teste com http://www.caelum.com.br e http://blog.caelum.com.br"
      links = Link.create_from tweet
      
      tweet.links.size.should == 2
      tweet.links[0].url = "http://www.caelum.com.br"
      tweet.links[1].url = "http://blog.caelum.com.br"
    end
    
    it "should not extract any link when there's no link for a given tweet" do
      Link.should_not_receive(:create)
      
      tweet = Tweet.new :text=>"Esse eh um teste sem link"
      links = Link.create_from tweet
      
      tweet.links.size.should == 0
    end
    
    it "should ignore link when it is just http:// (incomplete)" do
      Link.should_not_receive(:create)
      
      tweet = Tweet.new :text=>"Esse eh um teste http:// com link incompleto"
      links = Link.create_from tweet
      
      tweet.links.size.should == 0
    end
  end
  
  describe "#most_popular_today_from" do
    it "should return most popular links today for a given tag" do
      pending
    end
  end  
end
