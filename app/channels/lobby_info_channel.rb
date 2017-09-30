class LobbyInfoChannel < ApplicationCable::Channel
  def subscribed
    if current_player&.is_a?(Player)
      event = {
        event_type: 'player_join',
        player: current_player.uuid,
        render: ApplicationController.renderer.render(partial: 'shared/player_listing', locals: {player: current_player})
      }
      ActionCable.server.broadcast(current_player.lobby_channel, event)
    end
    stream_from current_player.lobby_channel
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
        game.init_game(current_player, ActionCable.server)
        event = {
          event_type: 'start_game',
          render: game.render_game_client(ApplicationController.renderer)
        }
        ActionCable.server.broadcast(current_player.lobby_channel, event)
      else
        debugger
        p "Unauthorized Game Start"
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
