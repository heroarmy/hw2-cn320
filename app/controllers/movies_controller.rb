class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    /@movies = Movie.all/
    @sort = params[:sort]
    @rating = params[:ratings]

    if @rating.nil?
      @rating = session[:rating]
    end

    if @sort.nil?
      @sort = session[:sort] 
    end

  
    @all_ratings = Movie.all_ratings           
    @array = []

    if @rating.nil?
      @array = @all_ratings
    else
      @rating.each_key do |key|
          @array << key
        end
    end

    @movies = Movie.order("#{params[:sort]} ASC")

    
     

    if !@rating.nil?
      @movies = Movie.find(:all,:conditions =>["rating IN(?)",@rating.keys],:order => @sort)
    end

    

    session[:rating] = @rating
    session[:sort] = @sort
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
