# https://developers.google.com/api-client-library/ruby/auth/web-app
require 'google/apis/analytics_v3'
require 'google/api_client/client_secrets'

class WelcomeController < ApplicationController
  before_action :authorize_ga_api, except: :oauthredirect

  def landing
    client_opts = JSON.parse(session["google-auth-client"])
    auth_client = Signet::OAuth2::Client.new(client_opts)

    analytics = Google::Apis::AnalyticsV3::AnalyticsService.new
    @results = analytics.get_ga_data('ga:103055258', '7daysAgo', 'yesterday', 'ga:newusers,ga:transactions,ga:transactionRevenue,ga:goal4Completions', dimensions: 'ga:source', filters: 'ga:source==CurlyByNature', options:{ authorization: auth_client })
  end

  def oauthredirect
    client_secrets = Google::APIClient::ClientSecrets.new(JSON.parse(ENV['GOOGLE_CLIENT_SECRETS']))
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/analytics.readonly',
      :redirect_uri => 'http://localhost:3000/oauthredirect'
    )

    if params["code"] 
      auth_client.code = params["code"]
      auth_client.fetch_access_token!
      auth_client.client_secret = nil # not sure why this is
      session["google-auth-client"] = auth_client.to_json
      return redirect_to root_path
    else
      google_auth_uri = auth_client.authorization_uri.to_s
      return redirect_to google_auth_uri
    end
  end
end
