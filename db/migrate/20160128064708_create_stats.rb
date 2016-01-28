class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.integer :views
      t.integer :channel_subscribers
      t.references :video
      t.references :report

      t.timestamps null: false
    end
  end
end
