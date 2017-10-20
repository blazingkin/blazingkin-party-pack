class ChangeFromGameDatum < ActiveRecord::Migration[5.0]
  def change
    drop_table :game_data
    change_table :game_sessions do |t|
      t.text :game_type
    end
  end
end
