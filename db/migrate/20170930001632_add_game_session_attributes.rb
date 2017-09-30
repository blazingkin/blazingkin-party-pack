class AddGameSessionAttributes < ActiveRecord::Migration[5.0]
  def change
    change_table :game_sessions do |t|
      t.column :short_id, :string
      t.column :host_ip, :string
    end
    add_index :game_sessions, :short_id, unique: true
  end
end
