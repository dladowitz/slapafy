require 'google/api_client/client_secrets'

class WelcomeController < ApplicationController
  def landing
    authenticate
  end

  def oauthredirect
    
  end


  private

  def authenticate
    client_secrets = Google::APIClient::ClientSecrets.load('google-web.json')
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/drive.metadata.readonly',
      :redirect_uri => 'http://localhost:3000/oauthredirect'
    )

    auth_uri = auth_client.authorization_uri.to_s

    redirect_to auth_uri
  end
end
