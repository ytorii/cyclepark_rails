class ContractsController < ApplicationController
  include SessionAction
  
  # edit action is allowed for only admin staffs.
  before_action :check_admin, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_contract, only: [:show, :edit, :update, :destroy]

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

  # GET /contracts/new
  def new
    @contract = Contract.new
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
        unless @contract.new_flag
          message = '契約を更新しました。'
        else
          message = '新規契約を登録しました。'
        end

        format.html { redirect_to leaf_path(@contract.leaf_id), notice: message }
        format.json { render :show, status: :created, location: @contract }
      else
        # @leaf is needed to show customer information.
        @leaf = Leaf.find(@contract.leaf_id)
        format.html { render template: "leafs/show" }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contracts/1
  # PATCH/PUT /contracts/1.json
  def update
    respond_to do |format|
      if @contract.update(update_params)
        format.html { redirect_to leaf_path(@contract.leaf_id), notice: '契約が変更されました。' }
        format.json { render :show, status: :ok, location: @contract }
      else
        @leaf = Leaf.find(@contract.leaf_id)
        format.html { render :edit }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contracts/1
  # DELETE /contracts/1.json
  def destroy
    respond_to do |format|
       if @contract.destroy
        format.html { redirect_to leaf_path(@contract.leaf_id), notice: '契約が削除されました。' }
        format.json { render :show, status: :ok, location: @contract }
      else
        @leaf = Leaf.find(@contract.leaf_id)
        format.html { render "leafs/show" }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contract
      @contract = Contract.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def create_params
      params.require(:contract).permit(:leaf_id, :contract_date, :term1, :money1, :term2, :money2, :skip_flag, :staff_nickname, seals_attributes: [:id, :sealed_flag])
    end

    def update_params
      params.require(:contract).permit(:id, :leaf_id, :contract_date, :term1, :money1, :term2, :money2, :skip_flag, :staff_nickname, seals_attributes: [:id, :sealed_flag, :sealed_date, :month, :staff_nickname])
    end
end
