module UrlHelper
  def extensions_path
  end
  
  def search_path
  end

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
