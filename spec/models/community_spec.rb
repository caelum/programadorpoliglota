require 'spec_helper'

describe Community do
  describe "#add_community" do
    it "should add a new community if all informations were added correctly" do
      tag = Tag.create :name=>'#java'
      community = Community.new :name=>'Guj', :url=>'http://www.guj.com.br', :tag=>tag
      community.save
      
      community.should be_valid
      
      new_community = Community.all.first
      new_community.url.should == 'http://www.guj.com.br'
      new_community.name.should == 'Guj'
      new_community.approved.should == false
    end
    
    it "should not be valid if any required information wasn't added" do
      tag = Tag.create :name=>'#java'
      community = Community.new :url=>'http://www.guj.com.br', :tag=>tag
      
      community.should_not be_valid
    end
    
    it "should not be valid with invalid url" do
      tag = Tag.create :name=>'#java'
      community = Community.new :name=>'Guj', :url=>'url invalida', :tag=>tag
      
      community.should_not be_valid
    end
    
    it "should be valid with a correct url" do
      tag = Tag.create :name=>'#java'
      community = Community.new :name=>'Guj', :url=>'http://www.guj.com.br', :tag=>tag
      
      community.should be_valid
    end
  end
end
