class GameSession < ApplicationRecord
    validates :short_id, presence: true, uniqueness: true
    has_many :players, dependent: :destroy
    after_touch :clear_association_cache

    class << self
        attr_accessor :stores
        GameSession.stores = {}
    end

    def game_datum=(data)
        GameSession.stores[self.id] = data
    end

    def game_datum
        GameSession.stores[self.id]
    end

    def game_session
        self
    end

    def group_lobby_channel
        "lobby-#{short_id}:host"
    end

    def player_lobby_channel
        "lobby-#{short_id}:client"
    end

    def host_lobby_channel
        group_lobby_channel
    end

    def lobby_channel
        "lobby-#{short_id}:info"
    end

    def game_client_channel
        "game-#{short_id}:client"
    end

    def game_host_channel
        "game-#{short_id}:host"
    end

    def game_service
        self.reload
        GameService.get_service(game_type)
    end

    def broadcast(opts)
        broadcast_host(opts)
        broadcast_players(opts)
    end

    def broadcast_host(opts)
        ActionCable.server.broadcast(game_host_channel, opts)
    end

    def broadcast_players(opts)
        ActionCable.server.broadcast(game_client_channel, opts)
    end

    def show(host_view, player_view)
        show_host(host_view)
        show_players(player_view)
    end

    def show_host(view, opts={})
        to_render = opts.merge({partial: view})
        ActionCable.server.broadcast(game_host_channel, {
            event_type: 'change_view',
            render: ApplicationController.renderer.render(to_render)
        })
    end

    def show_players(view, opts={})
        to_render = opts.merge({partial: view})
        ActionCable.server.broadcast(game_client_channel, {
            event_type: 'change_view',
            render: ApplicationController.renderer.render(to_render)
        })
    end

    SESSION_ID_LENGTH = 5
    SESSION_CHARACTERS_TO_CHOOSE = [*"A".."H",*"J".."N", *"P".."Z", *"2".."9"]
    def self.get_unique_short_id
        s_id = Array.new(SESSION_ID_LENGTH){SESSION_CHARACTERS_TO_CHOOSE.sample}.join
        if !GameSession.find_by(short_id: s_id)&.count.blank?
            return get_unique_short_id
        end
        return s_id
    end

    def self.new_game_session(opts={})
        fields = opts.merge({short_id: get_unique_short_id})
        new_session = GameSession.new(fields)
        return new_session if new_session.save
        return nil
    end

end
