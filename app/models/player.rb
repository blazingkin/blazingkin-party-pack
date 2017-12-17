class Player < ApplicationRecord
    belongs_to :game_session
    validates :client_ip, presence: true
    validates :game_session, presence: true
    validates :uuid, presence: true, uniqueness: true

    def lobby_channel
        game_session.lobby_channel
    end

    def group_lobby_channel
        "lobby-#{game_id}:client"
    end

    def player_lobby_channel
        group_lobby_channel
    end

    def player_personal_lobby_channel
        "lobby-#{game_id}-#{uuid}:client"
    end

    def host_lobby_channel
        game_session.group_lobby_channel
    end

    def game_id
        game_session.short_id
    end

    def game_client_channel
        game_session.game_client_channel
    end

    def game_host_channel
        game_session.game_host_channel
    end

    def game_personal_channel
        "game-#{game_id}-#{uuid}:client"
    end

    def game_service
        game_session.game_service
    end

    def show(view, opts={})
        to_render = opts.merge({partial: view})
        ActionCable.server.broadcast(game_personal_channel, {
            event_type: 'change_view',
            render: ApplicationController.renderer.render(to_render)
        })
    end

    def broadcast(data)
        ActionCable.server.broadcast(game_personal_channel, data)
    end

    RAND_MAX = 9999999
    def self.get_unique_id
        uuid = Random.rand(RAND_MAX)
        return uuid if Player.find_by(uuid: uuid)&.count.blank?
        return get_unique_id
    end

    FIRST_NAMES = %w(sad unbelievable awe-inspiring slow wet inky electric sticky thick nerdy cool tired energetic smelly hot cold
                    enigmatic clever crazy horse dog ramen famous ugly pretty thin large sexy green pink purple adorable adventurous
                    aggressive bloody brave charming clumsy confused white red orange delightful enchanting evil fair filthy grotesque
                    unique short tall obnoxious selfish greasy fragile grandiose dumb dumbest holy immaculate)
    LAST_NAMES = %w(turtle computer keyboard actor chair key backpack flashlight toilet egg waffle sword toast banana tape headphones
                    dictionary statue photograph mother-in-law cat monkey baby man woman car fruit cherry kitten balloon bird cake soda
                    spy underwear vegetable writer zebra sea squirrel pickle partner bee couch cloth cream donkey border hot-pocket tv-remote
                    phone automated-wiping-device)
    def self.create_new_player(opts={})
        player = Player.new(opts.merge(
                {uuid: get_unique_id, name: "#{FIRST_NAMES.sample} #{LAST_NAMES.sample}".titleize, score: 0}
        ))
        return player if player.save
        return nil
    end
end
