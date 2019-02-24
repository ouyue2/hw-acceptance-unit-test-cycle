require 'rails_helper'

describe MoviesController do
    
  describe "index action" do
    before :each do
      @fake_movie = double('Movie', :id => "1", :title => "Star Wars", :rating => "PG")
      allow(Movie).to receive(:find).with("1").and_return(@fake_movie)  
    end
    
    it "should show index" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "show action" do
    before :each do
      @fake_movie = double('Movie', :id => "1", :title => "Star Wars")
      allow(Movie).to receive(:find).with("1").and_return(@fake_movie)
    end
    
    it "should show a movie" do
      get :show, :id => "1"
      expect(response).to render_template("show")
    end
  end
  
  describe "edit action" do
    before :each do
      @fake_movie = double('Movie', :id => "1", :title => "Star Wars")
      allow(Movie).to receive(:find).with("1").and_return(@fake_movie)
    end
    
    it "should allow movie date to be changed" do
      get :edit, :id => "1"
      expect(response).to render_template("edit")
    end
  end
  
  describe "new action" do
    it "should show form for new movie" do
      get :new
      expect(response).to render_template("new")
    end
  end
  
  describe 'update action' do
    before :each do
      @fake_movie = double('Movie', :title => "Star Wars", :id => "1")
      allow(Movie).to receive(:find).with("1").and_return(@fake_movie)
    end
    
    it 'should update and show movie' do
      expect(@fake_movie).to receive(:update_attributes!)
      put :update, { :movie => { :title => "THX-1138"},  :id => "1" }
      expect(response).to redirect_to(movie_path(@fake_movie))
    end
  end
  
  describe 'create action' do
    it 'should create a new movie' do
      @fake_movie = double(:title => "Star Wars", :id => "1")
      post :create, { :movie => {:id => "1"} }
      expect(response).to redirect_to(movies_path)
    end
  end
    
  describe 'destroy action' do
    before :each do
      @fake_movie = double('Movie', :id => "1", :title => "Star Wars")
      allow(Movie).to receive(:find).with("1").and_return(@fake_movie)
    end
    
    it 'should destroy a movie' do
      expect(@fake_movie).to receive(:destroy)
      delete :destroy, {:id => "1"}
      expect(response).to redirect_to(movies_path)
    end
  end
  
  describe 'similar action' do
    it "should fail if no director" do
      @fake_movie = double('Movie', :id => "1", :title => "Star Wars", :director => nil)
      allow(Movie).to receive(:find).with("1").and_return(@fake_movie)
      get :similar, :id => "1"
      expect(response).to redirect_to(root_path)
    end
    
    it "should select movies with the same director" do
      @fake_movie = double('Movie', :id => "1", :title => "Star Wars", :director => "George Lucas")
      allow(Movie).to receive(:find).with("1").and_return(@fake_movie)
      expect(Movie).to receive(:where).with(:director => "George Lucas")
      get :similar, :id => "1"
    end
  end

end
