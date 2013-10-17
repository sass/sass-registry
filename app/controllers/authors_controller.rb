class AuthorsController < ApplicationController
  # GET /authors
  def index
    @authors = User.paginate :page => params[:page], :conditions => ["extensions_count > 0"], :order => 'name, email'
  end

  # GET /authors/1
  def show
    @author = User.authors.find(params[:id])
  end
end
