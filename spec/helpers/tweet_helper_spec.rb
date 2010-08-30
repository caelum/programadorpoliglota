require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the TweetHelper. For example:
#
# describe TweetHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe TweetHelper do
  describe '#next_page_link' do
    it 'should return the next page link' do
      helper.next_page_link(5, 3).should == '<a href="http://test.host/tweets/see_more/3/6" class="ver_mais">Ver mais</a>'
    end
  end
  
  describe '#previous_page_link' do
    it 'should return the previous page link' do
      helper.previous_page_link(5, 3).should == '<a href="http://test.host/tweets/see_more/3/4" class="ver_mais">Anteriores</a>'
    end
  end
end
