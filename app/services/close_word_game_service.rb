
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
            handle_player_distance_submission(game_session, player, data['guess'])
        when 'inverse_distance'

        when 'word_math'

        end
    end

    def receive_host_data(game_session, data)
        case data['type']
        when 'change_phase'
            if game_session.game_datum[:phase] == 'distance'
                game_session.game_datum[:phase] = 'inverse_distance'
            else
                game_session.game_datum[:phase] = 'word_math'
            end
        when 'start'
            word_dist_new_word(game_session)
        end
    end

    def init_game(game_session)
        game_session.game_datum[:phase] = 'distance'
        game_session.game_datum[:players] = game_session.players.map { |p|
         {name: p.name,
          uuid: p.uuid,
          points: 0,
          voted: false,
          distance: -1}
        }

    end

    private

    def word_dist_new_word(game_session)
        game_session.game_datum[:word] = WordToVecService.get_word
        ActionCable.server.broadcast(game_session.game_host_channel,{
            word: game_session.game_datum[:word].upcase
        })
    end

    def handle_player_distance_submission(game_session, player, guess)
        game_session.game_datum[:players].each do |p|
            if player.uuid == p[:uuid]
                unless p[:voted]
                    if !WordToVecService.has_word? guess
                        ActionCable.server.broadcast(player.game_personal_channel, {
                            error: "Sorry, I don't know that word"
                        })
                    else

                    end
                end
            end
        end
    end



end