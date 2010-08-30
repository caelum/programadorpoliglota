require 'spec_helper'

describe URLInformationExtractor do
  describe '#title' do
    it "should use the given url and use the user agent Mac Safari and return the title as it is" do
      agent = Object.new
      site_information = Object.new
      Mechanize.should_receive(:new).and_return(agent)
      agent.should_receive(:user_agent_alias=).with('Mac Safari')
      agent.should_receive(:get).with('http://www.example.com').and_return(site_information)
      site_information.should_receive(:title).and_return('A title')
      
      extractor = URLInformationExtractor.new 'http://www.example.com'
      extractor.title.should == 'A title'
    end
    
    it "should return the given url when an error is raised when retrieving the title" do
      url = 'http://www.example.com'
      agent = Object.new
      site_information = Object.new
      Mechanize.should_receive(:new).and_return(agent)
      agent.should_receive(:user_agent_alias=).with('Mac Safari')
      page = mock(Mechanize::Page)
      page.should_receive(:code).and_return(404)
      
      agent.should_receive(:get).once.with(url).and_raise(Mechanize::ResponseCodeError.new(page))
      
      extractor = URLInformationExtractor.new(url)
      extractor.title.should == url
    end
  end
  
  describe '#unwrap' do
    it 'should return the original url if there is no location header at the request' do
      original_url = 'http://www.example.com'
      parsed_url = Object.new
      URI.should_receive(:parse).with(original_url).and_return(parsed_url)
      response = Object.new
      Net::HTTP.should_receive(:get_response).with(parsed_url).and_return(response)
      response.should_receive(:to_hash).and_return({})
      
      extractor = URLInformationExtractor.new original_url
      extractor.unwrap.should == original_url
    end
    
    it 'should return the url from the location header if it exists' do
      original_url = 'http://www.example.com'
      parsed_url = Object.new
      URI.should_receive(:parse).with(original_url).and_return(parsed_url)
      response = Object.new
      Net::HTTP.should_receive(:get_response).with(parsed_url).and_return(response)
      location_header_from_response = {'location'=>['http://www.anURL.com']}
      response.should_receive(:to_hash).and_return(location_header_from_response)
      
      extractor = URLInformationExtractor.new original_url
      extractor.unwrap.should == 'http://www.anURL.com'
    end
  end
end