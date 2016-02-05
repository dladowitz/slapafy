class Video < ActiveRecord::Base
  has_many :stats
  after_create :set_title

  private 

  def set_title
    response = RestClient.get("https://www.googleapis.com/youtube/v3/videos?part=snippet&id=#{self.youtube_id}&key=#{ENV["GOOGLE_API_KEY"]}")
    response = JSON.parse(response.body)

    snippet    = response["items"][0]["snippet"]
    title      = snippet["title"]

    self.update_attributes title: title
  end
end
