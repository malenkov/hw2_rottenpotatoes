class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @selected_ratings = if (params[:ratings] != nil) then
      params[:ratings].respond_to?('keys') ? params[:ratings].keys : params[:ratings]
    else
      session[:ratings]
    end

    @sort_by = (params[:sort_by] != nil) ? params[:sort_by] : session[:sort_by]

    session[:sort_by] = @sort_by
    session[:ratings] = @selected_ratings

    if ((params[:sort_by] != @sort_by) || (params[:ratings] != @selected_ratings))
      redirect_to movies_path(:sort_by => @sort_by, :ratings => @selected_ratings)
    end

    @all_ratings = Movie.all_ratings()

    if (@sort_by == 'title')
      @title_class = 'hilite'
    end

    if (@sort_by == 'release_date')
      @release_date_class = 'hilite'
    end

    if (@selected_ratings == nil)
      @selected_ratings = []
    end

    if (@selected_ratings == [])
    	@movies = Movie.find(:all, :order => @sort_by)
    else
      @movies = Movie.where(:rating => @selected_ratings).order(@sort_by)
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
