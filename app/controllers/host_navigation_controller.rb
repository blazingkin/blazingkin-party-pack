class HostNavigationController < ApplicationController

    def index
        @game_session = GameSession.new_game_session(host_ip: request.remote_ip.to_s)
        cookies.signed[:session_id] = @game_session.id
        render 'index', locals: {game_session: @game_session}
    end

    def load_lobby
        @game_session = GameSession.find(cookies.signed[:session_id])
        render 'index', locals: {game_session: @game_session}
    end

end
