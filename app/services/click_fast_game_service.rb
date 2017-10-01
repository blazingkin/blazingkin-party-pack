class ClickFastGameService < GameService

    def render_game_client(game_session, renderer)
        renderer.render partial: 'games/client/click_fast'
    end

    def render_game_host(game_session, renderer)
        renderer.render partial: 'games/host/click_fast', locals: {players: game_session.players}
    end

    def receive_client_data(game_session, data, player)
        if data['click']
            score = game_session.game_datum.json[player.uuid.to_s] += 1
            game_session.game_datum.save
            ActionCable.server.broadcast(game_session.game_host_channel,
             {  data_type: 'click',
                player_uuid: player.uuid,
                player_score: score
            })
        end
    end

    def recieve_host_data(game_session, data)

    end

    def init_game(game_session)
        GameDatum.find_by(game_session: game_session.id)&.destroy!
        game_datum = GameDatum.create({game_type: 'click_fast'})
        game_session.update({game_datum: game_datum})
        game_session.game_datum.json = {}
        game_session.players.each do |p|
            game_session.game_datum.json[p.uuid.to_s] = 0
        end
        game_datum.save
    end

end