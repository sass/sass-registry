class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  include UrlHelper

  def can_edit?(model)
    case model
    when Extension
      !!(current_user && ((current_user.id == model.author_id) || current_user.admin?))
    when User
      !!(current_user && (current_user.id == model.id))
    else
      raise "unknown model #{model}:#{model.class}"
    end
  end
  helper_method :can_edit?

end
