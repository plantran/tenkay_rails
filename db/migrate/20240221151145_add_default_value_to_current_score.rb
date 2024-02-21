class AddDefaultValueToCurrentScore < ActiveRecord::Migration[7.0]
  def up
    change_column_default :players, :current_score, 0
  end

  def down
    change_column_default :players, :current_score, 0
  end
end
