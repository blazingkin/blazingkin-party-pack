require 'test_helper'

class HostNavigationControllerTest < ActionDispatch::IntegrationTest

  test "should get new session" do
    assert_difference "GameSession.count", +1 do
      get host_new_path
    end
  end

end
