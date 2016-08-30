class DailyContractsReportController < ApplicationController
  def index
    report = DailyContractsReport.new(params[:contracts_date])
    if report.valid?
      @contracts_date  = report.contracts_date
      @contracts_list  = report.contracts_list
      @contracts_total = report.contracts_total
    else
      respond_to do |format|
        format.html {
          redirect_to menu_path,
          alert: report.errors.full_messages
        }
      end
    end
  end
end
