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
    # sources
    # https://teamtreehouse.com/community/ruby-on-rails-params-hash-explained
    # https://stackoverflow.com/questions/9646815/conditionally-setting-css-style-from-ruby-controller
    # https://apidock.com/ruby/Array/uniq
    # http://mitrev.net/ruby/2015/11/13/the-operator-in-ruby/
    # https://stackoverflow.com/questions/12084507/what-does-the-map-method-do-in-ruby
    # https://stackoverflow.com/questions/5267950/how-to-use-the-where-method-from-activerecordquerymethods-in-order-to-limi
    # http://matthewcarriere.com/2008/06/23/using-select-reject-collect-inject-and-detect/
    # https://www.lynda.com/Ruby-Rails-tutorials/Ruby-Rails-5-Essential-Training/500551-2.html
    
    #redirect flag. If signalled, it will use flash.keep and redirect.
    @redirect = false

    #new init of movies. WTF was that?

    @movies = Movie.all
    @redirect = false
    if(@checked != nil)
      @movies = @movies.select { |m| @checked.key?(m.rating) and  @checked[m.rating]==true}      
    end
    
    #current session override for sorting
    if(params[:sort] == 'title')
      session[:sort] = params[:sort]
      @movies = @movies.sort_by{|x| x.title }
    elsif(params[:sort] == 'release_date')
      session[:sort] = params[:sort]
      @movies = @movies.sort_by{|x| x.release_date }
    elsif(session.key?(:sort) )
      params[:sort] = session[:sort]
      @redirect = true
    end
    
    #current session override for ratings
    if(params[:ratings] != nil)
      session[:ratings] = params[:ratings]
      @movies = @movies.select{ |x| params[:ratings].key?(x.rating) }
    elsif(session.key?(:ratings) )
      params[:ratings] = session[:ratings]
      @redirect = true
    end
    
    if @redirect == true
      flash.keep
      redirect_to movies_path(:sort => params[:sort], :ratings => params[:ratings] )
    end

    # reinitialize checked and the all ratings. I'm not sure why, but this code fixed an issue
    @all_ratings =  ['G','PG','PG-13','R']
    @checked = {}

    # After session
    if @checked != nil
      @checked = if params[:ratings] then params[:ratings].keys else @all_ratings end
      @checked.each do |rating|
        params[rating] = true
      end
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