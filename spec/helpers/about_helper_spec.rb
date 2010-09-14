require 'spec_helper'

describe AboutHelper do
  describe '#about_link' do
    it 'should return the about link with a correct id' do
      helper.about_link('someId').should == '<a href="/sobre" id="someId"><span>Apoie o <br /> movimento</span></a>'
    end
  end
end
