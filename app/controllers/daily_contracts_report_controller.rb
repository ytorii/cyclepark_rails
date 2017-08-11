# Controller for listing DailyContractsReport
class DailyContractsReportController < ApplicationController
  def index
    @report = DailyContractsReport.new(report_params)

    if @report.valid?
      result_parameters
    else
      error_respond
    end
  end

  private

  def report_params
    { contracts_date: params[:contracts_date],
      query: DailyContractsQuery }
  end

  def result_parameters
    @contracts_date  = @report.contracts_date
    @contracts_list  = @report.contracts_list
    @contracts_total = @report.contracts_total
  end

  def error_respond
    respond_to do |format|
      format.html do
        redirect_to menu_path, alert: @report.errors.full_messages
      end
    end
  end
end
