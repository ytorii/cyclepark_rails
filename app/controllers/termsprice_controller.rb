# Controller for termsprice, to get price by ajax.
class TermspriceController < ApplicationController
  def index
    termsprice = Termsprice.new(
      leaf_id: params[:leaf_id],
      term: params[:term]
    )

    if termsprice.valid?
      render json: { 'price' => termsprice.calc_price }
    else
      redirect_to menu_path, alert: termsprice.errors.full_messages
    end
  end
end
