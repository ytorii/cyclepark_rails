class SealsController < ApplicationController
  before_action :set_seal, only: [:update, :destroy]

  # PATCH/PUT /seals/1
  # PATCH/PUT /seals/1.json
  def update
    respond_to do |format|
      if @seal.update(seal_params)
        format.html { redirect_to leaf_path(params[:leaf_id]), notice: 'シール貼付情報を更新しました。' }
        format.json { render :show, status: :ok, location: @seal }
      else
        @leaf = Leaf.find(params[:leaf_id])
        format.html { render "leafs/show" }
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
