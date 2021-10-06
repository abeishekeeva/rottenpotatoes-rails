class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    ratings = params[:ratings].nil? ? [] : params[:ratings].keys   
    ratings = session[:ratings] if ratings.empty?
    @sort_parameter = params[:sort_parameter] || session[:sort_parameter]
    
    @ratings_hash = Hash[ratings.collect{ |item| [item, "1"]}]
    if session[:sort_parameter] != params[:sort_parameter] or session[:ratings] != ratings
      session[:sort_parameter] = @sort_parameter
      session[:ratings] = ratings
      redirect_to movies_path("sort_parameter" => @sort_parameter, "ratings" => @ratings_hash) 
    end

    @all_ratings = Movie.all_ratings
    @ratings_to_show = ratings     
    @movies = Movie.with_ratings(ratings)

    if not @sort_parameter.nil?
      @movies = @movies.order(@sort_parameter)
    end
      
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
