class LobbyInfoChannel < ApplicationCable::Channel
  def subscribed
    if current_player&.is_a?(Player)
      event = {
        event_type: 'player_join',
        player: current_player.uuid,
        render: ApplicationController.renderer.render(partial: 'shared/player_listing', locals: {player: current_player})
      }
      stream_from current_player.player_personal_lobby_channel
      ActionCable.server.broadcast(current_player.lobby_channel, event)
    end
    stream_from current_player.lobby_channel
    stream_from current_player.group_lobby_channel
  end

  def receive(payload)
    if payload['event_type'] == 'player_rename'
      if payload['player_id'] == current_player.uuid
        payload['new_name'] = CGI::escapeHTML(payload['new_name'])
        current_player.update({name: payload['new_name']})
        ActionCable.server.broadcast(current_player.lobby_channel, payload)
      end
    elsif payload['event_type'] == 'start_game'
      if current_player.is_a? GameSession
        game = GameService.get_service(payload['game'])
        current_player.game_datum = {}
        current_player.game_type = payload['game']
        current_player.save
        game.init_game(current_player)
        event = {
          event_type: 'start_game',
          render: game.render_game_client(current_player, ApplicationController.renderer)
        }
        ActionCable.server.broadcast(current_player.player_lobby_channel, event)
        event = {
          event_type: 'start_game',
          render: game.render_game_host(current_player, ApplicationController.renderer)
        }
        ActionCable.server.broadcast(current_player.host_lobby_channel, event)
      else
        p "Unauthorized Game Start"
      end
    elsif payload['event_type'] == 'game_over'
      if current_player.is_a? GameSession
        if payload['winner'].present?
          winner = Player.find_by({uuid: payload['winner']})
          winner.score += 1
          winner.save
        end
        current_player.game_datum = {}
        current_player.players.each do |pl|
          player_event = {
            event_type: 'reload_lobby',
            render: ApplicationController.renderer.render(partial: 'client_navigation/lobby',
                    locals: {player: pl, game_session: current_player})
          }
          ActionCable.server.broadcast(pl.player_personal_lobby_channel, player_event)
        end
        host_event = {
          event_type: 'reload_lobby',
          render: ApplicationController.renderer.render(partial: 'host_navigation/lobby',
                    locals: {game_session: current_player})
        }
        ActionCable.server.broadcast(current_player.group_lobby_channel, host_event)
      end
    end
  end

  def unsubscribed
    if current_player&.is_a?(Player)
      event = {
        event_type: 'player_leave',
        player: current_player.uuid
      }
      ActionCable.server.broadcast(current_player.lobby_channel, event)
    end
  end
end
