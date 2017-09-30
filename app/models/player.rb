class Player < ApplicationRecord
    belongs_to :game_session
    validates :client_ip, presence: true
    validates :game_session, presence: true
    validates :uuid, presence: true, uniqueness: true

    RAND_MAX = 9999999
    def self.get_unique_id
        uuid = Random.rand(RAND_MAX)
        return uuid if Player.find_by(uuid: uuid)&.count.blank?
        return get_unique_id
    end


    def self.create_new_player(opts={})
        player = Player.new(opts.merge({uuid: get_unique_id}))
        return player if player.save
        return nil
    end
end
