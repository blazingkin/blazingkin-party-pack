class AddCurrentGameToGameSession < ActiveRecord::Migration[5.0]
  def change
    change_table :game_data do |t|
      t.string :game_type
      t.belongs_to :game_session
    end
  end
end
