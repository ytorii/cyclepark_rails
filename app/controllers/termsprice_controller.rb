class TermspriceController < ApplicationController
  def index
    termsprice = Termsprice.new(
      leaf_id: params[:leaf_id],
      term: params[:term]
    )

    render json: { "price" => termsprice.getPrice }
  end
end