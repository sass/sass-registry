require 'test_helper'

class CreateExtensionTest < ActionDispatch::IntegrationTest

  test "must authenticate to create import extension" do
    get "/extensions/import"
    assert_response :redirect
  end

  test "create extension with valid url" do
    login "john@uservoice.com", "password"
    import_extension "git@github.com/jlong/css-spinners"
    assert_equal "/extensions/css-spinners", current_path
  end

  private
    
    def login(email, password)
      visit "/"
      click_link "Login"
      fill_in "Email", with: email
      fill_in "Password", with: password
      click_button "Log in"
    end

    def import_extension(project_url)
      visit "/extensions/import"
      fill_in "Enter your GitHub project URL:", with: project_url
      click_button "Add Extension"
    end
   
end
