class WordScrambleGameService < GameService

    def render_game_client(game_session, renderer)
        renderer.render partial: 'games/client/word_scramble'
    end

    def render_game_host(game_session, renderer)
        renderer.render partial: 'games/host/word_scramble', locals: {players: game_session.players}
    end

    def receive_client_data(game_session, data, player)

    end

    def recieve_host_data(game_session, data)

    end

    def init_game(game_session)
        GameDatum.find_by(game_session: game_session.id)&.destroy!
        game_datum = GameDatum.create({game_type: 'word_scramble'})
        game_session.update({game_datum: game_datum})
        game_session.game_datum.json = {}
        game_session.game_datum.json['words'] = {}
        game_datum.save
    end

end