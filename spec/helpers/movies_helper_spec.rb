require 'spec_helper'

describe MoviesHelper do

  before(:all) do
    class HelperTester
        include MoviesHelper
    end
  end

  describe 'check if the number is odd' do
    it "should return odd for 4" do
        HelperTester.new.oddness(4).should eq 'even'
    end
    it "should return 'even' for 3" do
         HelperTester.new.oddness(3).should eq 'odd'
    end
  end
end


