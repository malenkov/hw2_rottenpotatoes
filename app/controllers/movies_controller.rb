class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings()

	ratings = params[:ratings]
	if (ratings != nil)
		ratings = ratings.keys
		puts ratings
	end

    if (params[:sort_by] != nil)
	@sort_by = params[:sort_by]
    else
	@sort_by = params[:hidden_sort]
    end

    if (@sort_by != nil)
	if (@sort_by == 'title')
		@title_class = 'hilite'
		@refresh_sort = 'title'
	end

	if (@sort_by == 'release_date')
		@release_date_class = 'hilite'
		@refresh_sort = 'release_date'
	end
    end

    if (ratings == nil)
    	if (@sort_by != nil)
		@movies = Movie.find(:all, :order => @sort_by)
    	else	
		@movies = Movie.all
    	end
    else
	if (@sort_by != nil)
		@movies = Movie.where(:rating => ratings).order(@sort_by)
	else
		@movies = Movie.where(:rating => ratings)
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
