require 'spec_helper'

describe TweetObserver do
  describe '#after_create' do
    it 'should clean the cache when if the cached file does exists' do
      File.should_receive(:exists?).with('public/index.html').and_return(true)
      File.should_receive(:delete).with('public/index.html')
      observer = TweetObserver.instance
      observer.after_create Object.new
    end
    
    it 'should not clean the cache when if the cached file does not exists' do
      File.should_receive(:exists?).with('public/index.html').and_return(false)
      File.should_not_receive(:delete)
      observer = TweetObserver.instance
      observer.after_create Object.new
    end
  end
end
