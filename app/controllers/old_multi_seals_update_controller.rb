class MultiSealsUpdateController < ApplicationController
  class MultiSealsUpdate
    include ActiveModel::Model

    attr_accessor :seal_ids
  end

  def index
    @query = Leaf.ransack(ransack_params)
    @seals_list = @query.result.includes(:contracts).select(
      'number, seals.id as seal_id'
    )
  end

  def update
    
    respond_to do |format|
      if Seal.updateMultiSeal(update_params)
        format.html { redirect_to multi_seals_update_path, notice: 'シール情報を更新しました。' }
        format.json { render :index, status: :ok, location: @leaf }
      else
        format.html { render :index }
        format.json { render json: errors, status: :unprocessable_entity }
      end
    end

  end
  
  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def ransack_params

    # Seals months are saved with the day beginning of month
    # "2016-05" => "2016-05-01"
    params[:q][:contracts_seals_month_eq].concat("-01")

    params.require(:q).permit(
      :vhiecle_type_eq,
      :valid_flag_eq,
      :contracts_seals_month_eq,
      :contracts_seals_sealed_flag_eq
    )
  end

  def update_params
    # Seals months are saved with the day beginning of month
    # "2016-05" => "2016-05-01"
    params[:multi_seals_update][:month].concat("-01")

    params.require(:multi_seals_update)
      .permit(
        :month,
        :sealed_date,
        seal_ids: []
      )
  end
end
