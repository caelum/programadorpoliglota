require 'spec_helper'

describe TwitterQueryBuilder do
  describe 'build_queries_for_group' do
    it "should return the queries for the twitter api for the tags of a given tag group" do
      group = TagGroup.new
      group.tags << [Tag.new, Tag.new]
      last = Object.new
      Tweet.stub(:last_tweet_from_group).with(group).and_return(last)
      last.stub(:tweet_id).and_return(1)
      query = Object.new
      Twitter::Search.stub(:new).and_return(query)
      query.stub_chain(:lang, :per_page, :since)

      queries = TwitterQueryBuilder.build_queries_for_group group
      queries.size.should == 2
    end

  end
end
