class ClickFastGameService < GameService

    def init_game(game_session, action_cable_server)
        game_datum = GameDatum.new({game_type: 'click_fast'})
        game_session.update({game_datum: game_datum})
    end

end