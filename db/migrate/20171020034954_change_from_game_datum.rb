class ChangeFromGameDatum < ActiveRecord::Migration[5.0]
  def change
    change_table :game_sessions do |t|
      t.text :game_type
    end
  end
end
