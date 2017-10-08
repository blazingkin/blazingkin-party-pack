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
            elsif game_session.game_datum.store[:phase] == 'build'
                game_session.game_datum.store[:sentences] << {
                    sentence: data['sentence'].strip,
                    player: player.uuid
                }
            elsif game_session.game_datum.store[:phase] == 'vote'
                game_session.game_datum.store[:current_sentences][data['vote'].to_i][:votes] += 1
            end
        end
    
        def receive_host_data(game_session, data)
            if data['results']
                winning_id = round_winner(game_session)        
                sentences = game_session.game_datum.store[:current_sentences].map { |s| s[:sentence] }
                ActionCable.server.broadcast(game_session.game_host_channel, {
                    event_type: 'sentences',
                    render: ApplicationController.renderer.render(
                        partial: 'games/shared/sentence_builder/vote',
                        locals: {sentences: sentences, winner: winning_id}
                    )
                })
                if (winning_id != -1)
                    winning_player = game_session.game_datum.store[:current_sentences][winning_id][:sentence][:player]
                    game_session.game_datum.store[:points][winning_player] ||= 0
                    game_session.game_datum.store[:points][winning_player] += 1
                end
                game_session.game_datum.store[:current_sentences] = []
                return
            elsif data['phase']
                if data['phase'] == 'build'
                    game_session.game_datum.store[:phase] = 'build'
                    game_session.game_datum.store[:words] = game_session.game_datum.store[:words].uniq
                    game_session.game_datum.store[:sentences] = []
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
                elsif data['phase'] == 'vote'
                    game_session.game_datum.store[:phase] = 'vote'
                    game_session.game_datum.store[:points] = {}
                    game_session.game_datum.store[:sentences].shuffle!
                    ActionCable.server.broadcast(game_session.game_host_channel, {
                        event_type: 'change_view',
                        render: ApplicationController.renderer.render(
                            partial: 'games/host/sentence_builder/vote_phase'
                        )
                    })
                    ActionCable.server.broadcast(game_session.game_client_channel, {
                        event_type: 'change_view',
                        render: ApplicationController.renderer.render(
                            partial: 'games/client/sentence_builder/vote'
                        )
                    })
                end
            elsif data['next'] && game_session.game_datum.store[:phase] == 'vote'
                sentences = game_session.game_datum.store[:sentences].slice!(0, 4)
                if sentences.blank?
                    send_game_over(game_session)
                end
                game_session.game_datum.store[:current_sentences] = [].tap do |arr|
                    sentences.each do |s|
                        arr << {
                            votes: 0,
                            sentence: s
                        }
                    end
                end
                ActionCable.server.broadcast(game_session.game_host_channel, {
                    event_type: 'sentences',
                    render: ApplicationController.renderer.render(
                        partial: 'games/shared/sentence_builder/vote',
                        locals: {sentences: sentences, winner: nil}
                    )
                })
                ActionCable.server.broadcast(game_session.game_client_channel, {
                    event_type: 'sentences',
                    render: ApplicationController.renderer.render(
                        partial: 'games/shared/sentence_builder/vote',
                        locals: {sentences: sentences, winner: nil}
                    )
                })
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

        private

        def get_winner(game_session)
            winner = -1
            winning_score = 0
            game_session.game_datum.store[:points].each do |player, points|
                if points > winning_score
                    winner = player
                    winning_score = points
                end
            end
            winner
        end

        def send_game_over(game_session)
            winning_id = get_winner(game_session)
            winner_name = Player.find_by({uuid: winning_id}).name
            ActionCable.server.broadcast(game_session.game_host_channel, {
                event_type: 'change_view',
                render: ApplicationController.renderer.render(
                    partial: 'games/host/sentence_builder/game_over',
                    locals: {winner_name: winner_name, winning_id: winning_id}
                )
            })
        end

        def round_winner(game_session)
            winning_id = -1
            current_greatest = 0
            current_id = 0
            game_session.game_datum.store[:current_sentences].each do |se|
                if se[:votes] > current_greatest
                    current_greatest = se[:votes]
                    winning_id = current_id
                end
                current_id += 1
            end
            winning_id
        end
    
    end