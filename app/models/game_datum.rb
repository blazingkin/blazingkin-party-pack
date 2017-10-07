class GameDatum < ApplicationRecord
    belongs_to :game_session, touch: true
    validates :game_type, presence: true

    class << self
        attr_accessor :stores
        GameDatum.stores = {}
    end

    def self.clear_store(session_id)
        GameDatum.stores[session_id] = {}
    end

    def store
        GameDatum.stores[game_session.id]
    end

    def store=(obj)
        GameDatum.stores[game_session.id] = obj
    end


end
