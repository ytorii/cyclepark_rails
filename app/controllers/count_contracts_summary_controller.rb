class CountContractsSummaryController < ApplicationController
  include SessionAction

  def index
    @counts = CountContractsSummary.new().countContractsSummary()
  end
end
