require 'spec_helper'

describe Link do

  describe "#scan_for_urls" do
    it "should ignore link when it is just http:// (incomplete)" do
      text = "Esse eh um teste http:// com link incompleto"
      Link.scan_for_urls(text).size.should == 0      
    end

    it "should work with https" do
      text = "Esse eh um teste https://secure.com/a"
      Link.scan_for_urls(text)[0].should == "https://secure.com/a"
    end    

    it "should work with trailing marks: !" do
      text = "Esse eh um teste http://url.com/a!!!"
      Link.scan_for_urls(text)[0].should == "http://url.com/a"
    end    

    it "should work with trailing marks: . must be accepted, unfortunately" do
      text = "Esse eh um teste http://url.com/a. bla bla"
      Link.scan_for_urls(text)[0].should == "http://url.com/a."
    end
  end

  describe "#extract_from" do
    it "should extract all links and save then for a given tweet" do
      tag_java = TagGroup.new :name=>"#java"
      tweet = Tweet.new :text=>"Esse eh um teste com http://bit.ly/a1 e http://bit.ly/a2 #java", :tag_group => tag_java
      
      extractor = stub(URLInformationExtractor)
      URLInformationExtractor.should_receive(:new).with('http://bit.ly/a1').and_return(extractor)
      URLInformationExtractor.should_receive(:new).with('http://bit.ly/a2').and_return(extractor)
      extractor.should_receive(:unwrap).and_return('http://www.caelum.com.br')
      extractor.should_receive(:unwrap).and_return('http://blog.caelum.com.br')
      extractor.should_receive(:title).and_return('Caelum')
      extractor.should_receive(:title).and_return('Blog da Caelum')
          
      Link.create_from tweet
      Link.all.size.should == 2
    end
  end
  
  describe "#most_popular_for" do
    it "should return most popular links for a given tag ordered by quantity" do
      tag = TagGroup.create :name=>'#java'
      
      Link.create :url=>'http://www.caelum.com.br', :tag_group=>tag, :created_at => Time.now - 4.day
      Link.create :url=>'http://www.caelum.com.br', :tag_group=>tag, :created_at => Time.now - 5.day
      Link.create :url=>'http://www.caelum.com.br', :tag_group=>tag, :created_at => Time.now - 6.day
      Link.create :url=>'http://www.caelum.com.br', :tag_group=>tag, :created_at => Time.now - 15.day
      
      Link.create :url=>'http://blog.caelum.com.br', :tag_group=>tag, :created_at => Time.now - 2.day
      Link.create :url=>'http://blog.caelum.com.br', :tag_group=>tag, :created_at => Time.now - 5.day
      
      Link.create :url=>'http://www.sun.com/java', :tag_group=>tag, :created_at => Time.now - 20.day
      
      popular_links = Link.most_popular_for(tag)
      
      popular_links.size.should == 2
      popular_links.first.url.should == 'http://www.caelum.com.br'
      popular_links.last.url.should == 'http://blog.caelum.com.br'
    end
    
    it "should not return a link if it was tweeted more than seven days" do
      tag = TagGroup.create :name=>'#java'
      Link.create :url=>'http://www.sun.com/java', :tag_group=>tag, :created_at => Time.now - 8.day
      
      popular_links = Link.most_popular_for(tag)
      popular_links.size.should == 0
    end
  end  
  
end
