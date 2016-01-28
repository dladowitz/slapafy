class ReportsController < ApplicationController
  def index
    @reports = Report.all
  end

  def create
    @report = Report.create

    render :show
  end

  def show
  end
end
