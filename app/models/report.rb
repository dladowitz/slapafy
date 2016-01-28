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
      csv << ["YouTube Id", "Views", "Channel Subscribers", "Video Title"]
      self.stats.each do |stat|
        csv << [stat.video.youtube_id, stat.views, stat.channel_subscribers, stat.video.title]
      end
    end
  end

end


# ,
# , stat.views, stat.channel_subscribers, stat.video.title
