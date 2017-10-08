class GameService

    GAME_SERVICES = {
        'click_fast' => ClickFastGameService.new,
        'word_scramble' => WordScrambleGameService.new,
        'sentence_builder' => SentenceBuilderGameService.new
    }

    def self.get_service(game_name)
        return GAME_SERVICES.values.sample if game_name == 'random'
        GAME_SERVICES[game_name]
    end

    def render_game_client(game_session, renderer)
        renderer.render plain: 'Ooops, something went wrong (client)'
    end

    def render_game_host(game_session, renderer)
        renderer.render plain: 'Ooops, something went wrong (host)'
    end

    def receive_client_data(game_session, data, player)

    end

    def receive_host_data(game_session, data)

    end

    def init_game(game_session)
        
    end

end