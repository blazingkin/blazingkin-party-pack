class ClientNavigationController < ApplicationController

    def index
        p params[:request_id]
    end

end
