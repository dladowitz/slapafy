# https://developers.google.com/api-client-library/ruby/auth/web-app
require 'google/apis/analytics_v3'
require 'google/api_client/client_secrets'

class WelcomeController < ApplicationController
  skip_before_action :authorize_ga_api, only: :oauthredirect
  
  def landing
  end

  # TODO move to application controller
  def oauthredirect
    client_secrets = Google::APIClient::ClientSecrets.new(JSON.parse(ENV['GOOGLE_CLIENT_SECRETS']))
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      :scope => ['https://www.googleapis.com/auth/analytics.readonly','https://www.googleapis.com/auth/analytics'],
      :redirect_uri => ENV["GOOGLE_API_REDIRECT_URI"]
    )

    if params["code"] 
      auth_client.code = params["code"]
      auth_client.fetch_access_token!
      auth_client.client_secret = nil # not sure why this is
      session["google-auth-client"] = auth_client.to_json
      return redirect_to root_url
    else
      google_auth_uri = auth_client.authorization_uri.to_s
      return redirect_to google_auth_uri
    end
  end
end
