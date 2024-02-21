class AddDefaultValueToMaxScore < ActiveRecord::Migration[7.0]
  def up
    change_column :games, :max_score, :integer, default: 10_000
  end

  def down
    change_column :games, :max_score, :integer, default: nil
  end
end
