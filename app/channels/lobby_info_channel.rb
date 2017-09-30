class LobbyInfoChannel < ApplicationCable::Channel
  def subscribed
    if current_player&.is_a?(Player)
      event = {
        event_type: 'player_join',
        player: current_player.uuid
      }
      ActionCable.server.broadcast("lobby-#{current_player.game_id}:info", event)
    end
    stream_from "lobby-#{params['game_id']}:info"
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
