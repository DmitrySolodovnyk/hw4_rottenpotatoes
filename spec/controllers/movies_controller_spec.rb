require 'spec_helper'

describe MoviesController do
  describe 'search similar movies' do
        it 'should call the Movie method to search movie by id' do
          fake_result=mock('Movie', :director => 'George Lucas')
          Movie.should_receive(:find).with('1').and_return(fake_result)
          get :similar, {:id => 1}
        end
        it 'should put notice and redirect to movies if no director defined' do
          fake_result=mock('Movie', :director => '', :title => "Star Wars")
          Movie.should_receive(:find).with('1').and_return(fake_result)
          get :similar, {:id => 1}
          flash[:notice].should be
          response.should redirect_to(movies_path())
        end
        context 'after valid search' do
          before :each do
            @fake_result=mock('Movie', :director => 'George Lucas', :title => 'Star Wars')
            Movie.should_receive(:find).with('1').and_return(@fake_result)
            @fake_similar=[mock('Movie'),mock('Movie')]
            Movie.should_receive(:find_all_by_director).with(@fake_result.director).and_return(@fake_similar)

            get :similar, {:id => 1}
          end
          it 'should select results for rendering' do
             response.should render_template('similar')
          end
          it 'shuld make search result availavle to the template' do
             assigns(:similar_movies).should == @fake_similar
          end
       end
    end
end