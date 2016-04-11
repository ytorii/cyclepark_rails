class LeafsController < ApplicationController
  include SessionAction

  before_action :set_leaf, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:index, :destroy]

  # GET /leafs
  # GET /leafs.json
  def index
    @leafs = Leaf.all
  end

  # GET /leafs/1
  # GET /leafs/1.json
  def show
    @query = Leaf.ransack params[:q]
    @contracts_list = @leaf.contracts.all
    @contract = @leaf.contracts.build
    @contract.seals.build
  end

  # GET /leafs/new
  def new
    @leaf = Leaf.new
    @leaf.build_customer
  end

  # GET /leafs/1/edit
  def edit
  end

  # POST /leafs
  # POST /leafs.json
  def create

    @leaf = Leaf.new(leaf_params)

    respond_to do |format|
      if @leaf.save
        format.html { redirect_to leaf_path(@leaf), notice: '顧客情報を登録しました。' }
        format.json { render :show, status: :created, location: @leaf }
      else
        format.html { render :new }
        format.json { render json: @leaf.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leafs/1
  # PATCH/PUT /leafs/1.json
  def update
    respond_to do |format|
      if @leaf.update(leaf_params)
        format.html { redirect_to leaf_path(@leaf), notice: '顧客情報を変更しました。' }
        format.json { render :show, status: :ok, location: @leaf }
      else
        format.html { render :edit }
        format.json { render json: @leaf.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leafs/1
  # DELETE /leafs/1.json
  def destroy
    @leaf.destroy
    respond_to do |format|
      format.html { redirect_to leafs_url, notice: '顧客情報を削除しました。' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leaf
      @leaf = Leaf.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leaf_params
      params.require(:leaf).permit(:number, :vhiecle_type, :student_flag, :largebike_flag, :valid_flag, :start_date, :last_date, customer_attributes: [:id, :first_name, :last_name, :first_read, :last_read, :sex, :address, :phone_number, :cell_number, :receipt, :comment] )
    end
end
