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
      csv << ["Video Title", "YouTube Id", "Views", "Cost", "Channel Subscribers", "GA New Users", "GA Transactions", "GA Revenue", "GA Goal 4 Completions"]
      self.stats.each do |stat|
        csv << [stat.video.title, stat.video.youtube_id, stat.views, stat.video.cost, stat.channel_subscribers, stat.new_users, stat.transactions, stat.transaction_revenue, stat.goal_4_completions]
      end
    end
  end

end


# ,
# , stat.views, stat.channel_subscribers, stat.video.title
