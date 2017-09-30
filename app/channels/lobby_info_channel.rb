class LobbyInfoChannel < ApplicationCable::Channel
  def subscribed
    stream_from "lobby-#{params['game_id']}:info"
  end

  def unsubscribed
    if current_player&.is_a?(Player)
      event = {
        event_type: 'player_leave',
        player: current_player.uuid
      }
      ActionCable.server.broadcast('lobby-:info', event)
    end
  end
end
