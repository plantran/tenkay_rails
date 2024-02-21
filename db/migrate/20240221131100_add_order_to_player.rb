class AddOrderToPlayer < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :order, :integer, null: false
  end
end
