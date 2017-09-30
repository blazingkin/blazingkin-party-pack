class GameChannel < ApplicationCable::Channel
  def subscribed
    if current_player.is_a?(Player)
      stream_from current_player.game_client_channel
      stream_from current_player.game_personal_channel
    else
      stream_from current_player.game_host_channel
      game = current_player.game_service
      event = {
        event_type: 'change_view',
        render: game.render_game_host(ApplicationController.renderer)
      }
      ActionCable.server.broadcast(current_player.game_host_channel, event)
    end
  end

  def receive(data)
    
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
