class GameService

    GAME_SERVICES = {
        "click_fast" => ClickFastGameService
    }


    def self.get_service(game_name)
        GAME_SERVICES[game_name].new
    end

    def render_game_client(game_session, renderer)
        renderer.render plain: 'Ooops, something went wrong (client)'
    end

    def render_game_host(game_session, renderer)
        renderer.render plain: 'Ooops, something went wrong (host)'
    end

    def receive_client_data(game_session, data, player)

    end

    def recieve_host_data(game_session, data)

    end

    def init_game(game_session, action_cable_server)
        
    end

end