class GameSession < ApplicationRecord
    validates :short_id, presence: true, uniqueness: true
    has_many :players, dependent: :destroy
    has_one :game_datum, dependent: :destroy

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

    def game_type
        game_datum.game_type
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
        GameService.get_service(game_datum.game_type)
    end

    SESSION_ID_LENGTH = 5
    def self.get_unique_short_id
        s_id = Array.new(SESSION_ID_LENGTH){[*"A".."Z", *"1".."9"].sample}.join
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
