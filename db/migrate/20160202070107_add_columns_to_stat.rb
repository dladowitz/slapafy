class AddColumnsToStat < ActiveRecord::Migration
  def change
    add_column :stats, :new_users, :integer
    add_column :stats, :transactions, :integer
    add_column :stats, :transaction_revenue, :integer
    add_column :stats, :goal_4_completions, :integer
  end
end
