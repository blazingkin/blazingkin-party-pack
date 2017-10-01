class RemoveStoreFromGameData < ActiveRecord::Migration[5.0]
  def change
    remove_column :game_data, :store
  end
end
