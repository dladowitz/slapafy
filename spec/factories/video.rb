# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video do
    youtube_id "abc123"
    title "Slaps Review"
    ga_source_medium "hair nation / youtube"
    cost 900

    # skip callback
    after(:build) { |video| video.class.skip_callback(:create, :after, :set_title) }
  end
end
