class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.datetime :started_at, null: true
      t.datetime :finished_at, null: true
      t.integer :max_score, null: false

      t.timestamps
    end
  end
end
