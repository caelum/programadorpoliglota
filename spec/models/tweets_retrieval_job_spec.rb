require 'spec_helper'

describe TweetsRetrievalJob do
  describe '#import_all_groups_tweets' do
    it "should not add new tweets when no tag group is found" do
      job = TweetsRetrievalJob.new
      job.should_not_receive(:import_tweets_of)
      job.import_all_groups_tweets
    end

    it 'should import tweets of each tag group registered' do
      TagGroup.create :name=>'Ruby'
      TagGroup.create :name=>'Java'

      job = TweetsRetrievalJob.new
      job.should_receive(:import_tweets_of).twice

      job.import_all_groups_tweets
    end
  end

  describe '#import_tweets_of' do
    it 'should ask for a query of a tag group and create new tweet from it' do
      group = TagGroup.new :name=>'Ruby'
      queries = Object.new
      TwitterQueryBuilder.should_receive(:build_queries_for_group).with(group).and_return(queries)
      Tweet.should_receive(:create_tweets_from_queries).with(queries,group)
      job = TweetsRetrievalJob.new
      job.import_tweets_of(group)
    end
  end
end
