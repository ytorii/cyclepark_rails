# Controller for list CountContractsSummary.
class CountContractsSummaryController < ApplicationController
  include SessionAction

  # This action is allowed for only admin staffs.
  before_action :check_admin

  def index
    if month_validator.valid?
      @counts = counts_summary.report_summary
    else
      respond_to do |format|
        format.html do
          redirect_to menu_path, alert: month_validator.errors.full_messages
        end
      end
    end
  end

  private

  def month_validator
    @validator ||= DateFormatValidator.new(params[:count_month])
  end

  def counts_summary
    CountContractsSummary.new(params[:count_month])
  end
end
