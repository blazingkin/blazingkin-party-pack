class ClientNavigationController < ApplicationController

    def index

    end

    def connect
        @game_session = GameSession.find_by({short_id: params[:game_id].upcase})
        if @game_session.nil?
            flash[:warning] = "You got the join code wrong. Try looking at the TV. (Yeah John, I'm talking to you)"
            redirect_to client_url
            return
        end
        @player = Player.find_by(id: cookies.signed[:player_id]) || Player.create_new_player({
            client_ip: request.remote_ip.to_s,
            game_session: @game_session,
        })
        cookies.signed[:player_id] = @player.id
        render 'lobby', locals: {game_session: @game_session, player: @player}
    end

end
