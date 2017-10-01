class GameSessionTransitioningFlag < ActiveRecord::Migration[5.0]
  def change
    change_table :game_sessions do |t|
      t.boolean :is_reloading_lobby
    end
  end
end
