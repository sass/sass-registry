class HomeController < ApplicationController
  def index
    @extensions = Extension.order("created_at DESC").limit(6)
    @authors = User.authors.order("random()").limit(10)
  end
end
