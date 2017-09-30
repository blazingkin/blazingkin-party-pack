class ClientNavigationController < ApplicationController

    def index

    end

    def connect
        @game_session = GameSession.find_by({short_id: params[:game_id]})
        if @game_session.blank?
            flash[:warning] = "You got the join code wrong. Try looking at the TV."
            redirect_to client_url
        end
        @player = Player.create_new_player({
            client_ip: request.remote_ip.to_s,
            game_session: @game_session,
        })
        render 'lobby'
    end

    def set_name
        game_session = GameSession.find_by({short_id: params[:game_id]})
        player = game_session.players
    end

end
