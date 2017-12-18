require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest

  test "Should load welcome page" do
    get root_path
    assert_response :success
  end

  test "Clicking on new game button should start new game" do
    assert_difference "GameSession.count", +1 do
      visit('/')
      click_button('host_new_game_bttn')
      assert_equal host_new_path, current_path
    end
  end

#  Capybara doesn't change location when window.location.replace is used in JS
#  test "Should be able to join session" do
#    assert_difference "Player.count", +1 do
#      visit('/')
#      click_button('join_game_bttn')
#      assert_equal client_path, current_path
#      fill_in('game-id', with: 'ABCDE')
#      click_button('client-connect-to-game-with-id')
#    end
#  end

end
