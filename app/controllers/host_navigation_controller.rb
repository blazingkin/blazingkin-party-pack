class HostNavigationController < ApplicationController

    def index
        @game_session = GameSession.new_game_session(host_ip: request.remote_ip.to_s)
        cookies.signed[:session_id] = @game_session.id
    end
end
