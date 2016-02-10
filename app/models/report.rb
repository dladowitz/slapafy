class Report < ActiveRecord::Base
  has_many :stats

  # Class Methods
  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |report|
        csv << report.attributes.values_at(*column_names)
      end
    end
  end

  # Instance Methods
  def to_csv
    CSV.generate do |csv|
      csv << ["Video Title", "Source/Medium", "YouTube Id", "Channel Subscribers", "Views", "Cost", "GA New Users", "GA Transactions", "GA Revenue", "GA Goal 4 Completions", "ROI", "Cost/Sub ($)", "Rev/Sub ($)"]
      stats.each do |stat|
        csv << [stat.video.title, stat.video.ga_source_medium, stat.video.youtube_id, stat.channel_subscribers, stat.views, "$#{stat.video.cost}", stat.new_users, stat.transactions, "$#{stat.transaction_revenue}", stat.goal_4_completions, stat.video_roi, stat.cost_per_subscriber, stat.revenue_per_subscriber]
      end
    end
  end
end
