require 'test_helper'

class ClientNavigationControllerTest < ActionDispatch::IntegrationTest

  test "Should get page to connect" do
    get client_path
    assert_response :success
  end

  test "Should connect to game" do
    get '/client/ABCDE'
    assert_response :success
  end

  test "Should be redirected with invalid code" do
    get '/client/RANDOM'
    assert_redirected_to client_path
    assert_not flash[:warning].empty?
  end

end
