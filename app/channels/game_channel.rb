class GameChannel < ApplicationCable::Channel
  def subscribed
    if current_player.is_a?(Player)
      stream_from current_player.game_client_channel
      stream_from current_player.game_personal_channel
    else
      stream_from current_player.game_host_channel
    end
  end

  def receive(data)
    if current_player.is_a?(Player)
      current_player.game_service.receive_client_data(current_player.game_session, data, current_player)
    else
      current_player.game_service.receive_host_data(current_player.game_session, data)
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
