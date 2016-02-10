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

  it "correcty calculates video_roi" do
    stat = create :stat
    roi = (stat.transaction_revenue/stat.video.cost.to_f).round(2)
    expect(stat.video_roi).to eq roi
  end
end
