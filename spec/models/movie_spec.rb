require 'spec_helper'

describe Movie do
   it 'should define all ratings' do
     Movie.all_ratings.should be
   end

   describe 'Search similar by director'
    it 'should call the find method' do
        Movie.should_receive(:find_all_by_director).with('director')
        Movie.new(:director=>'director').find_similar()
    end
end
