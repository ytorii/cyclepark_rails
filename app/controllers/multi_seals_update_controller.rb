class MultiSealsUpdateController < ApplicationController
  def index
    @query = Leaf.ransack(ransack_params)

    numbers_sealsid_list =  @query.result.includes(:contracts).
                            select( 'number, seals.id as seal_id')

    @unsealed_list = UpdateMultiSeals.new(
      numbers_sealsid_list: numbers_sealsid_list,
      sealed_date: Date.current,
      staff_nickname: session[:nickname]
    )
  end

  def update
    @unsealed_list = UpdateMultiSeals.new(update_params)
    
    respond_to do |format|
      if @unsealed_list.updateSelectedSeals(update_params)
        format.html { redirect_to multi_seals_update_path,
                      notice: 'シール情報を更新しました。' }
        format.json { render :index, status: :ok,
                      location: multi_seals_update_path }
      else
        format.html { redirect_to menu_path,
                      notice: @unsealed_list.errors.full_messages }
        format.json { render json: errors,
                      status: :unprocessable_entity }
      end
    end
  end
  
  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def ransack_params

    # Seals months are saved with the day beginning of month
    # "2016-05" => "2016-05-01"
    params[:q][:contracts_seals_month_eq].concat("-01")

    params.require(:q)
      .permit(
        :vhiecle_type_eq,
        :valid_flag_eq,
        :contracts_seals_month_eq,
        :contracts_seals_sealed_flag_eq
      )
  end

  def update_params
    # Seals months are saved with the day beginning of month
    # "2016-05" => "2016-05-01"
    #params[:multi_seals_update][:month].concat("-01")

    params.require(:update_multi_seals_form)
      .permit(
        :staff_nickname,
        :sealed_date,
        numbers_sealsid_list: []
      )
  end
end
