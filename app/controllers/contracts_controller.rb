# Controller to list, show, edit, create, delete contracts
class ContractsController < ApplicationController
  include SessionAction
  include AjaxHelper

  # edit action is allowed for only admin staffs.
  before_action :check_admin, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_contract, only: [:show, :edit, :update, :destroy]

  CREATE_SUCCESS = '新規契約を登録しました。'.freeze
  EXTEND_SUCCESS = '契約を更新しました。'.freeze
  UPDATE_SUCCESS = '契約が変更されました。'.freeze
  DELETE_SUCCESS = '契約が削除されました。'.freeze

  # GET /contracts
  # GET /contracts.json
  def index
    @leaf = Leaf.find(params[:leaf_id])
    @contracts = @leaf.contracts.all
  end

  # GET /contracts/1
  # GET /contracts/1.json
  def show
    @leaf = Leaf.find(params[:leaf_id])
    @contract = @leaf.contracts.find(params[:id])
  end

  # GET /contracts/1/edit
  def edit
    @leaf = Leaf.find(params[:leaf_id])
  end

  # POST /contracts
  # POST /contracts.json
  def create
    @contract = Contract.new(create_params)

    respond_to do |format|
      if @contract.save
        # Response for ajax request is javascript.
        format.js { ajax_redirect_to_leaf_notice(create_message) }
      else
        # To run Leaf's show method, page needs to be redirected.
        # As Only a few inputs, re-input is a little work!
        alert_message = @contract.errors.full_messages
        format.js { ajax_redirect_to_leaf_alert(alert_message) }
      end
    end
  end

  # PATCH/PUT /contracts/1
  # PATCH/PUT /contracts/1.json
  def update
    respond_to do |format|
      if @contract.update(update_params)
        format.html { redirect_to_leaf_notice(UPDATE_SUCCESS) }
        format.json { render :show, status: :ok, location: @contract }
      else
        unprocessable_response(format)
      end
    end
  end

  # DELETE /contracts/1
  # DELETE /contracts/1.json
  def destroy
    respond_to do |format|
      if @contract.destroy
        format.html { redirect_to_leaf_notice(DELETE_SUCCESS) }
        format.json { render :show, status: :ok, location: @contract }
      else
        unprocessable_response(format)
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contract
    @contract = Contract.find(params[:id])
  end

  def redirect_to_leaf_notice(message)
    redirect_to leaf_path(@contract.leaf_id), notice: message
  end

  def redirect_to_leaf_alert(message)
    redirect_to leaf_path(@contract.leaf_id), alert: message
  end

  def unprocessable_response(format)
    format.html { redirect_to_leaf_alert(@contract.errors.full_messages) }
    format.json { render json: @contract.errors, status: :unprocessable_entity }
  end

  # In redirect with ajax, flash messages should be set directly,
  # not as format method's argument.
  def ajax_redirect_to_leaf_notice(message)
    flash[:notice] = message
    render ajax_redirect_to(@contract.leaf_id)
  end

  def ajax_redirect_to_leaf_alert(message)
    flash[:alert] = message
    render ajax_redirect_to(@contract.leaf_id)
  end

  def create_message
    if @contract.new_flag
      CREATE_SUCCESS
    else
      EXTEND_SUCCESS
    end
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def create_params
    params.require(:contract).permit(
      :leaf_id, :contract_date,
      :term1, :money1, :term2, :money2,
      :skip_flag, :staff_nickname,
      seals_attributes: [:id, :sealed_flag]
    )
  end

  def update_params
    params.require(:contract).permit(
      :id,
      :leaf_id, :contract_date,
      :term1, :money1, :term2, :money2,
      :skip_flag, :staff_nickname,
      seals_attributes: [
        :id,
        :sealed_flag, :sealed_date, :month, :staff_nickname
      ]
    )
  end
end
