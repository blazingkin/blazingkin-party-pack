class GameDatum < ApplicationRecord
    belongs_to :game_session, touch: true
    validates :game_type, presence: true
    serialize :store, Hash

end
