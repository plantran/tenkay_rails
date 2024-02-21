class AddCurrentAndNextPlayerToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :current_player_id, :integer, null: true
    add_column :games, :next_player_id, :integer, null: true

    add_index :games, :current_player_id
    add_index :games, :next_player_id
  end
end
