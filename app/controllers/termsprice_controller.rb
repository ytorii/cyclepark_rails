# Controller for termsprice, to get price by ajax.
class TermspriceController < ApplicationController
  def index
    termsprice = Termsprice.new(
      leaf_id: params[:leaf_id],
      term: params[:term]
    )

    render json: { 'price' => termsprice.calc_price }
  end
end
