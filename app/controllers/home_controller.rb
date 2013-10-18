class HomeController < ApplicationController
  def index
    @extensions = Extension.find(:all, order: "created_at DESC", limit: 4)
    @authors = User.authors.find(:all, order: "random()", limit: 5)
  end
end
