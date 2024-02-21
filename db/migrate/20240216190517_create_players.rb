class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.integer :current_score
      t.bigint :game_id, null: true
      t.string :name

      t.index :game_id

      t.timestamps
    end
  end
end
