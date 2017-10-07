class SentenceBuilderGameService < GameService
    
        def render_game_client(game_session, renderer)
            renderer.render partial: 'games/client/sentence_builder/word_input'
        end
    
        def render_game_host(game_session, renderer)
            renderer.render partial: 'games/host/sentence_builder/welcome', locals: {players: game_session.players}
        end
    
        def receive_client_data(game_session, data, player)
            if game_session.game_datum.store[:phase] == 'word_submission'
                game_session.game_datum.store[:words] << data['word'].upcase
            end
        end
    
        def receive_host_data(game_session, data)
            if data['phase']
                if data['phase'] == 'build'
                    game_session.game_datum.store[:phase] = 'build'
                    game_session.game_datum.store[:words] = game_session.game_datum.store[:words].uniq
                    ActionCable.server.broadcast(game_session.game_host_channel, {
                        event_type: 'change_view',
                        render: ApplicationController.renderer.render(
                            partial: 'games/host/sentence_builder/sentence_building_phase'
                        )
                    })
                    game_session.players.each do |player|
                        ActionCable.server.broadcast(player.game_personal_channel, {
                            event_type: 'change_view',
                            render: ApplicationController.renderer.render(
                                partial: 'games/client/sentence_builder/sentence_builder',
                                locals: {words: game_session.game_datum.store[:words].sample(5)})
                        })
                    end
                end
            end
        end
    
        def init_game(game_session)
            game_session.reload
            GameDatum.find_by(game_session: game_session.id)&.destroy!
            game_datum = GameDatum.create({game_type: 'sentence_builder'})
            game_session.update({game_datum: game_datum})
            game_session.game_datum.store = {}
            game_session.game_datum.store[:phase] = 'word_submission'
            game_session.game_datum.store[:words] = []
        end
    
    end