class CountContractsSummaryController < ApplicationController
  def index
    @query = Leaf.ransack params[:q]
    @counts = Leaf.countContractsSummary
  end
end
