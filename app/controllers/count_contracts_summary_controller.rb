class CountContractsSummaryController < ApplicationController
  def index
    @counts = Leaf.countContractsSummary
    p @counts
  end
end
