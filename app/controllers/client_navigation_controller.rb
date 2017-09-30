class ClientNavigationController < ApplicationController

    def index

    end

    def connect
        @game_session = GameSession.find_by({short_id: params[:game_id]})
        if @game_session.nil?
            flash[:warning] = "You got the join code wrong. Try looking at the TV. (Yeah John, I'm talking to you)"
            redirect_to client_url
            return
        end
        @player = Player.create_new_player({
            client_ip: request.remote_ip.to_s,
            game_session: @game_session,
        })
        cookies.signed[:session_id] = @game_session.id
        cookies.signed[:player_id] = @player.id
        render 'lobby'
    end

    def set_name
        game_session = GameSession.find_by({short_id: params[:game_id]})
        player = game_session.players
    end

end
