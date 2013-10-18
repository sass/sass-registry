module UrlHelper
  def login_path
    new_user_session_path
  end

  def logout_path
    destroy_user_session_path
  end

  def signup_path
    new_user_registration_path
  end
end
