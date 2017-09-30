class GameDatum < ApplicationRecord
    belongs_to :game_session
    validates :game_type, presence: true
end
