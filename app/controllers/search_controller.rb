# Right now this only searches extensions, but it would be great if it could search all objects
# in the system in the future.
class SearchController < ApplicationController

  def search
    @query, @page = params[:q], params[:page]
    @extensions = Extension.basic_search(@query).paginate(page: @page) unless @query.blank?
  end
  
  protected
  
    def results?
      !@query.blank? && @extensions.size > 0
    end
    helper_method :results?
  
end
