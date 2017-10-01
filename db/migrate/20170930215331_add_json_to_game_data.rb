class AddJsonToGameData < ActiveRecord::Migration[5.0]
  def change
    change_table :game_data do |t|
      t.json :json
    end
  end
end
