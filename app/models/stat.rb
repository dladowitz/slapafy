class Stat < ActiveRecord::Base
  belongs_to :video
  belongs_to :report

  validates :video_id, :report_id, :views, :channel_subscribers, :new_users, :transaction_revenue, :transactions, :goal_4_completions, presence: true

  def video_roi
    if self.video.cost > 0 && self.transaction_revenue > 0
      (self.transaction_revenue/self.video.cost.to_f).round(2)
    else
      "---"
    end
  end
end
