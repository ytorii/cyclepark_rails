class DailyContractsReportController < ApplicationController
  def index
    @report = DailyContractsReport.new(params[:contract_date])
  end
end
