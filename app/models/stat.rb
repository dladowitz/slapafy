class Stat < ActiveRecord::Base
  belongs_to :video
  belongs_to :report

  validates :video_id, :report_id, :views, :channel_subscribers, :new_users, :transaction_revenue, :transactions, :goal_4_completions, presence: true

  def video_roi
    if video.cost > 0 && transaction_revenue > 0
      (transaction_revenue / video.cost.to_f).round(2)
    else
      "---"
    end
  end

  def cost_per_subscriber
    if video.cost > 0 && channel_subscribers > 0
      (video.cost / channel_subscribers.to_f).round(5)
    else
      "---"
    end
  end

  def revenue_per_subscriber
    if transaction_revenue > 0 && channel_subscribers > 0
      (transaction_revenue / channel_subscribers.to_f).round(5)
    else
      "---"
    end
  end

  def cost_per_view
    if video.cost > 0 && views > 0
      (video.cost / views.to_f).round(5)
    else
      "---"
    end
  end

  def revenue_per_view
    if transaction_revenue > 0 && views > 0
      (transaction_revenue / views.to_f).round(5)
    else
      "---"
    end
  end
end
