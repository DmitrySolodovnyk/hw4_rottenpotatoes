require 'spec_helper'

describe MoviesController do

  describe 'search similar movies' do
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
            @fake_result.should_receive(:find_similar).and_return(@fake_similar)

            get :similar, {:id => 1}
          end

          it 'should call the Movie method to search movie by id' do
           # Gone with refactoring - nthing to do
           # fake_result=mock('Movie', :director => 'George Lucas')
           # Movie.should_receive(:find).with('1').and_return(fake_result)
           # get :similar, {:id => 1}
          end

          it 'should select results for rendering' do
             response.should render_template('similar')
          end
          it 'shuld make search result availavle to the template' do
             assigns(:similar_movies).should == @fake_similar
          end
       end
    end

    describe 'Create' do
        before :each do
            fake_movie=mock('Movie', :title=>'fake')
            Movie.should_receive(:create!).with('fake').and_return(fake_movie)
            post :create, {:movie => 'fake'}
        end
        it 'should call the Movie method' do
        end
        it 'should put notice to user' do
            flash[:notice].should be
        end
        it 'redirect to home page' do
            response.should redirect_to(movies_path())
        end
    end
    context 'Modify exiting movies' do
        before :each do
          @fake_movie=mock('Movie', :director => 'George Lucas', :title => 'Star Wars', :id =>'1')
          Movie.should_receive(:find).with('1').and_return(@fake_movie)
        end
        
       describe 'Update' do
          it 'should update the movie by calling model method' do
            @fake_movie.should_receive(:update_attributes!)
            put :update, {:id => '1'}
            flash[:notice].should be
            response.should redirect_to(movie_path(@fake_movie))
          end
       end
       describe 'Destroy' do
          it 'should update the movie by calling destroy method' do
            @fake_movie.should_receive(:destroy)
            delete :destroy, {:id => '1'}
            flash[:notice].should be
            response.should redirect_to(movies_path())
          end
       end
       describe 'Edit' do
         it 'Should find the move and make results available to the Edit template' do
   #        fake_movie=mock('Movie', :director => 'George Lucas', :title => 'Star Wars')
   #        Movie.should_receive(:find).with('1').and_return(fake_movie)
           get :edit, {:id => 1}
           assigns(:movie).should == @fake_movie
           response.should render_template('edit')
         end
       end
       describe 'Show' do
         it 'Should find the move and make results available to the Show template' do
           get :show, {:id => 1}
           assigns(:movie).should == @fake_movie
           response.should render_template('show')
        end
       end
    end

    describe 'Show all movies list' do
      before :each do
        @fake_movies=[mock('Movie'),mock('Movie')]
      end
      
      it 'Should redirect to RESTfull if sort order presents in parameters' do
        get :index  , {:sort=>'title'}
#        response.should redirect_to(movies_path(:sort=>'title'))
       response.should redirect_to('/movies?&sort=title')
      end

      it 'Should redirect to RESTfull if rating presents in parameters' do
        get :index  , {:ratings=> {:G=>'1'} }
        response.should redirect_to(movies_path(:ratings=> {:G=>'1'}))
      end
      
      it 'Should redirect to RESTfull if sort order presents in session' do
        get :index  , {}, {:sort=>'release_date'}
#        response.should redirect_to(movies_path(:sort=>'title'))
       response.should redirect_to('/movies?&sort=release_date')
      end
      
      it 'Should retrive movies list from Movie model' do
        Movie.should_receive(:find_all_by_rating).and_return(@fake_movie)
        get :index
        assigns(:movies).should == @fake_movie
        response.should render_template('index')
      end
    end
end