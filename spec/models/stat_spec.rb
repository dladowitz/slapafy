require 'rails_helper'

describe Stat do
  it { should validate_presence_of :report_id }
  it { should validate_presence_of :video_id }
  it { should validate_presence_of :views }
  it { should validate_presence_of :new_users }
  it { should validate_presence_of :transactions }
  it { should validate_presence_of :transaction_revenue }
  it { should validate_presence_of :goal_4_completions }

  it "has a valid factory" do
    stat = create :stat
    expect(stat).to be_instance_of Stat
  end

  it "correctly calculates video_roi" do
    stat = create :stat
    roi = (stat.transaction_revenue/stat.video.cost.to_f).round(2)
    expect(stat.video_roi).to eq roi
  end

  it "correctly calculates cost_per_subscriber" do
    stat = create :stat
    cpsub = (stat.video.cost / stat.channel_subscribers.to_f).round(5)
    expect(stat.cost_per_subscriber).to eq cpsub
  end

  it "correctly calculates revenue_per_subscriber" do
    stat = create :stat
    rpsub = (stat.transaction_revenue / stat.channel_subscribers.to_f).round(5)
    expect(stat.revenue_per_subscriber).to eq rpsub
  end

  it "correctly calculates cost_per_view" do
    stat = create :stat
    cpv = (stat.video.cost / stat.views.to_f).round(5)
    expect(stat.cost_per_view).to eq cpv
  end

  it "correctly calculates revenue_per_view" do
    stat = create :stat
    rpv = (stat.transaction_revenue / stat.views.to_f).round(5)
    expect(stat.revenue_per_view).to eq rpv
  end

  it "correctly calculates cost_per_lead" do
    stat = create :stat
    cpl = (stat.video.cost / stat.new_users.to_f).round(5)
    expect(stat.cost_per_lead).to eq cpl
  end

  it "correctly calculates cost_per_action" do
    stat = create :stat
    cpa = (stat.video.cost / stat.transactions.to_f).round(0)
    expect(stat.cost_per_action).to eq cpa
  end
end
