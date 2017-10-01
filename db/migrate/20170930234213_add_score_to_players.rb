class AddScoreToPlayers < ActiveRecord::Migration[5.0]
  def change
    change_table :players do |t|
      t.integer :score
    end
  end
end
