class DailyContractsReportController < ApplicationController
  def index
    @query = Contract.ransack({daily_contracts_scope: ransack_params})
    @contracts_lists = @query.result
    @contracts_total = Contract.calcContractsSummary(ransack_params)
  end

  def ransack_params
    report_date = params.require(:q)
                    .permit(:daily_contracts_scope)[:daily_contracts_scope]

    # The blank input causes selection of all contracts!!
    report_date = Date.current if report_date.blank?

    report_date
  end
end
