require 'test_helper'

class ClientNavigationControllerTest < ActionDispatch::IntegrationTest

  test "Should get page to connect" do
    get client_path
    assert_response :success
  end

  test "Should connect to game" do
    assert_difference 'Player.count', +1 do
      get '/client/ABCDE'
      assert_response :success
    end
  end

  test "Should be redirected with invalid code" do
    assert_difference 'Player.count', 0 do
      get '/client/RANDOM'
      assert_redirected_to client_path
      assert_not flash[:warning].empty?
    end
  end

end
