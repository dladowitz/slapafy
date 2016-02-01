class AddGaSourceMediumToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :ga_source_medium, :string
  end
end
