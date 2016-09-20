# Controller for seals update, delete
class SealsController < ApplicationController
  include AjaxHelper

  before_action :set_seal, only: [:update, :destroy]

  UPDATE_SUCCESS = 'シール貼付情報を更新しました。'.freeze

  # PATCH/PUT /seals/1
  # PATCH/PUT /seals/1.json
  def update
    respond_to do |format|
      @leaf = Leaf.find(params[:leaf_id])

      if @seal.update(seal_params)
        update_success_format(format)
      else
        update_error_format(format)
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_seal
    @seal = Seal.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def seal_params
    params.require(:seal).permit(
      :contract_id,
      :month,
      :sealed_flag,
      :sealed_date,
      :staff_nickname
    )
  end

  def update_success_format(format)
    format.js do
      flash[:notice] = UPDATE_SUCCESS
      render ajax_redirect_to(@leaf.id)
    end
  end

  def update_error_format(format)
    format.js do
      flash[:alert] = @seal.errors.full_messages
      render ajax_redirect_to(@leaf.id)
    end
  end
end
