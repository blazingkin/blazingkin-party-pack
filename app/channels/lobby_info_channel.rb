class LobbyInfoChannel < ApplicationCable::Channel
  def subscribed
    if current_player&.is_a?(Player)
      event = {
        event_type: 'player_join',
        player: current_player.uuid,
        render: ApplicationController.renderer.render(partial: 'shared/player_listing', locals: {player: current_player})
      }
      ActionCable.server.broadcast("lobby-#{current_player.game_id}:info", event)
    end
    stream_from "lobby-#{params['game_id']}:info"
  end

  def receive(payload)
    if payload['event_type'] == 'player_rename'
      if payload['player_id'] == current_player.uuid
        payload['new_name'] = CGI::escapeHTML(payload['new_name'])
        ActionCable.server.broadcast("lobby-#{current_player.game_id}:info", payload)
      end
    end
  end

  def unsubscribed
    if current_player&.is_a?(Player)
      event = {
        event_type: 'player_leave',
        player: current_player.uuid
      }
      ActionCable.server.broadcast("lobby-#{current_player.game_id}:info", event)
    end
  end
end
