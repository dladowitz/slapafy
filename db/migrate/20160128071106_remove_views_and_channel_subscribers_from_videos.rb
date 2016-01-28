class RemoveViewsAndChannelSubscribersFromVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :views, :integer
    remove_column :videos, :channel_subscribers, :integer
  end
end
