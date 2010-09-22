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
    it "should extract all links for a given tweet" do
      tag_java = Tag.new :name=>"#java"
      tweet = Tweet.new :text=>"Esse eh um teste com http://bit.ly/a1 e http://bit.ly/a2 #java"
      tweet.tag = tag_java
      
      extractor = stub(URLInformationExtractor)
      URLInformationExtractor.should_receive(:new).with('http://bit.ly/a1').and_return(extractor)
      URLInformationExtractor.should_receive(:new).with('http://bit.ly/a2').and_return(extractor)
      extractor.should_receive(:unwrap).and_return('http://www.caelum.com.br')
      extractor.should_receive(:unwrap).and_return('http://blog.caelum.com.br')
      extractor.stub(:title)
      
      Link.should_receive(:create).with(:url=>'http://www.caelum.com.br', :tag=>tag_java, :quantity => 1, :title=>anything()).and_return(Link.new)
      Link.should_receive(:create).with(:url=>'http://blog.caelum.com.br', :tag=>tag_java, :quantity => 1, :title=>anything()).and_return(Link.new)
      Link.should_receive(:find_by_tag_id_and_url).twice.and_return(nil)
          
      Link.create_from tweet
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
