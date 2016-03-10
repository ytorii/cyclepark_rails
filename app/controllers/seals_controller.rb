class SealsController < ApplicationController
  before_action :set_seal, only: [:show, :edit, :update, :destroy]

  # GET /seals
  # GET /seals.json
  def index
    @seals = Seal.all
  end

  # GET /seals/1
  # GET /seals/1.json
  def show
  end

  # GET /seals/new
  def new
    @seal = Seal.new
  end

  # GET /seals/1/edit
  def edit
  end

  # POST /seals
  # POST /seals.json
  def create
    @seal = Seal.new(seal_params)

    respond_to do |format|
      if @seal.save
        format.html { redirect_to @seal, notice: 'Seal was successfully created.' }
        format.json { render :show, status: :created, location: @seal }
      else
        format.html { render :new }
        format.json { render json: @seal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /seals/1
  # PATCH/PUT /seals/1.json
  def update
    respond_to do |format|
      if @seal.update(seal_params)
        format.html { redirect_to @seal, notice: 'Seal was successfully updated.' }
        format.json { render :show, status: :ok, location: @seal }
      else
        format.html { render :edit }
        format.json { render json: @seal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seals/1
  # DELETE /seals/1.json
  def destroy
    @seal.destroy
    respond_to do |format|
      format.html { redirect_to seals_url, notice: 'Seal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seal
      @seal = Seal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def seal_params
      params.require(:seal).permit(:contract_id, :month, :sealed_flag, :sealed_date, :staff_nickname)
    end
end
