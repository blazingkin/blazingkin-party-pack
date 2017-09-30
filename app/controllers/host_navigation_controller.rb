class HostNavigationController < ApplicationController

    def index
        @game_session = GameSession.new_game_session(host_ip: request.remote_ip.to_s)
        p @game_session
    end
end
