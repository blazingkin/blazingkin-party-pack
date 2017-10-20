require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest

  test "Should load welcome page" do
    get root_path
    assert_response :success
  end

end
