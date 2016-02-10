# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stat do
    association :report
    association :video
    views 10000
    channel_subscribers 500000
    new_users 900
    transactions 25
    transaction_revenue 1500
    goal_4_completions 50
  end
end
