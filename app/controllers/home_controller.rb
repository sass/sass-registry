class HomeController < ApplicationController
  def index
    @extensions = Extension.order("created_at DESC").limit(4)
    @authors = User.authors.order("random()").limit(5)
  end
end
