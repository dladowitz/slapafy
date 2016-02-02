class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize_ga_api

  def authorize_ga_api
    return redirect_to "/oauthredirect" unless session["google-auth-client"]
  end
end
