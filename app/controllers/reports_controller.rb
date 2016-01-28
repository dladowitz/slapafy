class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :destroy]

  def index
    @reports = Report.all

    respond_to do |format|
      format.html
      format.csv { send_data @reports.to_csv, filename: "slapafy_all_reports.csv" }
    end
  end

  def create
    @report = Report.create
    @current_videos = Video.all

    create_stats

    render :show
  end

  def show
    respond_to do |format|
      format.html
      format.csv { send_data @report.to_csv, filename: "slapafy_report_#{@report.id}.csv" }
    end
  end

  def destroy
    @report.delete
    redirect_to reports_path
  end


  private

  def set_report
    @report = Report.find params[:id]
  end

  def create_stats
    @current_videos.each do |video|
      # Get Views & Channel Id
      response = RestClient.get("https://www.googleapis.com/youtube/v3/videos?part=statistics,snippet&id=#{video.youtube_id}&key=#{ENV["GOOGLE_API_KEY"]}")
      response = JSON.parse(response.body)

      statistics = response["items"][0]["statistics"]
      snippet    = response["items"][0]["snippet"]

      view_count = statistics["viewCount"]
      channel_id = snippet["channelId"]

      # Get Subscriber Count
      response = RestClient.get("https://www.googleapis.com/youtube/v3/channels?part=statistics&id=#{channel_id}&key=#{ENV["GOOGLE_API_KEY"]}")
      response = JSON.parse(response.body)

      statistics = response["items"][0]["statistics"]
      subscriber_count = statistics["subscriberCount"]

      video.stats.create report_id: @report.id, views: view_count, channel_subscribers: subscriber_count
    end
  end
end
