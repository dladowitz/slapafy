require 'rails_helper'


describe ReportsController do
  describe "GET index" do
    subject { get :index }

    it "returns the index template" do
      get :index
      expect(response).to render_template :index
    end
  end
end
