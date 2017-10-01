class ChangeFormatOfJsonStorage < ActiveRecord::Migration[5.0]
  def change
    change_table :game_data do |t|
      remove_column :game_data, :json
      t.text :store
    end
  end
end
