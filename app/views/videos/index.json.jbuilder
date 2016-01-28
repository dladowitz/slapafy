json.array!(@videos) do |video|
  json.extract! video, :id, :youtube_id, :view, :channel_subscribers
  json.url video_url(video, format: :json)
end
