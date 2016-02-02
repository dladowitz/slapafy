class AddCostToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :cost, :integer
  end
end
