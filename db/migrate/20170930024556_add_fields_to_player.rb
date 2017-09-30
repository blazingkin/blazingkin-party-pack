class AddFieldsToPlayer < ActiveRecord::Migration[5.0]
  def change
    change_table :players do |t|
      t.string :name
      t.string :client_ip
      t.integer :uuid, index: true
      t.belongs_to :game_session, index: true
    end
  end
end
