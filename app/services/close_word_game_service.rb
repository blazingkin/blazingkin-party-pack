
class CloseWordGameService < GameService

    def render_game_client(game_session, renderer)
        renderer.render partial: 'games/client/close_words/display_distance'                
    end

    def host_view(game_session)
        case game_session.game_datum[:phase]
        when nil, 'distance'
            'games/host/close_words/distance'
        when 'inverse_distance'
            'games/host/close_words/inv_distance'
        end
    end

    def render_game_host(game_session, renderer)
        renderer.render(partial: host_view(game_session))
    end

    def receive_client_data(game_session, data, player)
        case game_session.game_datum[:phase]
        when 'distance'
            handle_player_distance_submission(game_session, player, data['guess'].downcase)
        when 'inverse_distance'
            handle_player_distance_submission(game_session, player, data['guess'].downcase, true)
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
            game_session.show_host(host_view(game_session))
        when 'end_submissions'
            player_distance_end_round(game_session, game_session.game_datum[:phase] == 'inverse_distance')
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
          guess: '',
          voted: false,
          distance: 100}
        }

    end

    private

    def word_dist_new_word(game_session)
        game_session.game_datum[:word] = WordToVecService.get_word
        game_session.broadcast_host({
            word: game_session.game_datum[:word].upcase
        })
    end

    def handle_player_distance_submission(game_session, player, guess, inverse=false)
        game_session.game_datum[:players].each do |p|
            if player.uuid == p[:uuid]
                unless p[:voted]
                    if !WordToVecService.has_word? guess
                        player.broadcast({error: "Sorry, I don't know that word"})
                    else
                        if guess.pluralize != game_session.game_datum[:word].pluralize
                            p[:voted] = true
                            p[:guess] = guess
                        else
                            player.broadcast({error: "Nice try, that doesn't work"})
                        end
                    end
                end
            end
        end
    end

    def calculate_distances(game_session)
        game_session.game_datum[:players].each do |p|
            if p[:voted]
                p[:distance] = WordToVecService.vector_distance(p[:guess], game_session.game_datum[:word])
                p[:voted] = false
            else
                p[:guess] = ""
                p[:distance] = 0
            end
        end
    end

    def player_distance_end_round(game_session, inverse=false)
        winner = nil
        winner_distance = inverse ? 0 : 100
        less_than = lambda {|x,y| x < y}
        less_than = lambda {|x, y| y < x} if inverse
        calculate_distances(game_session)
        game_session.game_datum[:players].each do |p|
            if !p[:guess].blank? && less_than.call(p[:distance], winner_distance)
                winner = p
                winner_distance = p[:distance]
            end
        end
        winner[:points] += 1 if winner
        game_session.broadcast_host({
            results: ApplicationController.renderer.render(partial: 'games/host/close_words/scores',
                                                           locals: {players: game_session.game_datum[:players]})
        })
        word_dist_new_word(game_session)
    end


end