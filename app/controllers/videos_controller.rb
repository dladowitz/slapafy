require 'google/apis/analytics_v3'
require 'google/api_client/client_secrets'

class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.all
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
  end

  # GET /videos/new
  def new
    @video = Video.new
    client_opts = JSON.parse(session["google-auth-client"])

    auth_client = Signet::OAuth2::Client.new(client_opts)
    analytics = Google::Apis::AnalyticsV3::AnalyticsService.new

    begin
      results = analytics.get_ga_data('ga:103055258', '7daysAgo', 'yesterday', 'ga:sessions', dimensions: 'ga:sourceMedium', options:{ authorization: auth_client })
    rescue Signet::AuthorizationError => e
      return redirect_to "/oauthredirect"
    end

    @video_names = results.rows.map{|source| source[0]}
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params)

    # TODO create a class or helper for this
    # Get View Count and Channel ID
    response = RestClient.get("https://www.googleapis.com/youtube/v3/videos?part=snippet&id=#{@video.youtube_id}&key=#{ENV["GOOGLE_API_KEY"]}")
    response = JSON.parse(response.body)

    snippet    = response["items"][0]["snippet"]
    title      = snippet["title"]

    @video.update_attributes title: title

    respond_to do |format|
      if @video.save
        format.html { redirect_to @video, notice: 'Video was successfully created.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url, notice: 'Video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:youtube_id, :views, :channel_subscribers, :title, :ga_source_medium, :cost)
    end
end
