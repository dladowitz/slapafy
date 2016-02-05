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

    # If @analytics is nill authorization has expired
    if @analytics
      render :show
    else
      return redirect_to "/oauthredirect"
    end
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

      youtube   = youtube_stats(video)
      @analytics = google_analytics_stats(video)

      # If authorization has expired this breaks
      if @analytics.try(:totals_for_all_results)
        video.stats.create({report_id: @report.id, 
                            views: youtube[:view_count], 
                            channel_subscribers: youtube[:subscriber_count], 
                            new_users: @analytics.totals_for_all_results["ga:newusers"],
                            transactions: @analytics.totals_for_all_results["ga:transactions"],
                            transaction_revenue: @analytics.totals_for_all_results["ga:transactionRevenue"],
                            goal_4_completions: @analytics.totals_for_all_results["ga:goal4Completions"]
                          })
      else
        puts "Analytics not found. Setting up for redirect and reauthorization"
        @analytics = nil
      end
    end
  end

  def youtube_stats(video)
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
      
      results = {view_count: view_count, subscriber_count: subscriber_count}
      return results
  end

  # TODO move to a class
  def google_analytics_stats(video)
    client_opts = JSON.parse(session["google-auth-client"])
    auth_client = Signet::OAuth2::Client.new(client_opts)

    analytics = Google::Apis::AnalyticsV3::AnalyticsService.new

    # TODO figure out how to handle timeout
    begin
      results = analytics.get_ga_data("ga:103055258", 
                                    "2015-05-29", 
                                    "yesterday", 
                                    "ga:newusers,ga:transactions,ga:transactionRevenue,ga:goal4Completions", 
                                    dimensions: "ga:sourceMedium", 
                                    filters: "ga:sourceMedium==#{video.ga_source_medium}", 
                                    options:{ authorization: auth_client }
                                    )
    rescue StandardError => e
      puts "Error Calling Google API for Analytics v3: #{e}"
      # This would be the best place to redirect, but having a problem actually execution after redirect. 
      # return redirect_to "/oauthredirect"
    end

    return results
  end
end
