class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #citations
    # https://stackoverflow.com/questions/9646815/conditionally-setting-css-style-from-ruby-controller
    # https://apidock.com/ruby/Array/uniq
    # http://mitrev.net/ruby/2015/11/13/the-operator-in-ruby/
    # https://stackoverflow.com/questions/12084507/what-does-the-map-method-do-in-ruby
    # https://stackoverflow.com/questions/5267950/how-to-use-the-where-method-from-activerecordquerymethods-in-order-to-limi
    @all_ratings = Movie.order(:rating).select(:rating).map(&:rating).uniq
    @checked = if params[:ratings] then params[:ratings].keys else @all_ratings end
    @checked.each do |rating|
      params[rating] = true
    end

    if params[:sort]
      @movies = Movie.order(params[:sort])
    else
      @movies = Movie.where(:rating => @checked)
    end
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