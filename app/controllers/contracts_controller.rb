class ContractsController < ApplicationController
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
  end

  # POST /contracts
  # POST /contracts.json
  def create
    @contract = Contract.new(contract_params)

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
      if @contract.update(contract_params)
        format.html { redirect_to @contract, notice: 'Contract was successfully updated.' }
        format.json { render :show, status: :ok, location: @contract }
      else
        format.html { render :edit }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contracts/1
  # DELETE /contracts/1.json
  def destroy
    @contract.destroy
    respond_to do |format|
      format.html { redirect_to contracts_url, notice: 'Contract was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contract
      @contract = Contract.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contract_params
      params.require(:contract).permit(:leaf_id, :contract_date, :term1, :money1, :term2, :money2, :skip_flag, :staff_nickname, seals_attributes: [:id, :sealed_flag])
    end
end
