module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_player

    def connect
      self.current_player = find_verified_user
    end

    def disconnect
      if self.current_player&.is_a?(Player) && !self.current_player.game_session.is_reloading_lobby
        self.current_player.destroy!
      end
    end

    private
      def find_verified_user
        if current_user = Player.find_by({id: cookies.signed[:player_id]})
          current_user
        elsif game_session = GameSession.find_by({id: cookies.signed[:session_id]})
          game_session
        else
          reject_unauthorized_connection
        end
      end

  end
end
