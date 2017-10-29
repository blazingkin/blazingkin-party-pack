
class CloseWordGameService < GameService

    def render_game_client(game_session, renderer)
        case game_session.game_datum[:phase]
            when nil, 'distance'
                renderer.render partial: 'games/client/close_words/display_distance'                
            when 'inverse_distance'

            when 'word_math'
        end
    end

    def render_game_host(game_session, renderer)
        renderer.render partial: 'games/host/close_words/distance'
    end

    def receive_client_data(game_session, data, player)
        case game_session.game_datum[:phase]
        when 'distance'
            ActionCable.server.broadcast(game_session.game_host_channel,
            {
                word: WordToVecService.get_word.upcase
            })
        when 'inverse_distance'

        when 'word_math'

        end
    end

    def receive_host_data(game_session, data)

    end

    def init_game(game_session)
        game_session.game_datum[:phase] = 'distance'
        game_session.game_datum[:players] = game_session.players.map { |p|
         {name: p.name,
          uuid: p.uuid,
          points: 0,
          voted: 0}
        }

    end

    private


end