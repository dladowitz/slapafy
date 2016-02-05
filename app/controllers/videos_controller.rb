require 'google/apis/analytics_v3'
require 'google/api_client/client_secrets'

class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  def index
    @videos = Video.all
  end

  def show
  end

  def new
    @video = Video.new
    
    @video_names = get_ga_source_medium_list
  end

  def edit
    @video_names = get_ga_source_medium_list
  end

  def create
    @video = Video.new(video_params)

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

  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url, notice: 'Video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def mass_new

  end

  def mass_create
    videos = Array.new
    file = params[:file].tempfile

    CSV.foreach(file) do |video|
      videos << video
    end

    videos.each do |video|
      Video.create youtube_id: video[0], cost: video[1].to_i, ga_source_medium: video[2]
    end

    redirect_to videos_path
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def video_params
    params.require(:video).permit(:youtube_id, :views, :channel_subscribers, :title, :ga_source_medium, :cost)
  end

  def get_ga_source_medium_list
    client_opts = JSON.parse(session["google-auth-client"])

    auth_client = Signet::OAuth2::Client.new(client_opts)
    analytics = Google::Apis::AnalyticsV3::AnalyticsService.new
    
    begin
      results = analytics.get_ga_data('ga:103055258', '2015-05-29', 'yesterday', 'ga:sessions', dimensions: 'ga:sourceMedium', options:{ authorization: auth_client })
    rescue StandardError => e
      puts e
      return redirect_to "/oauthredirect"
    end

    # TODO Probably a more effecient way to do this
    video_names = results.rows.map{|source| source[0]}
    return video_names.sort {|a1, a2| a1.downcase <=> a2.downcase}
  end
end
