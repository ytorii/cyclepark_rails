# Controller for index and update multi seals
class MultiSealsUpdateController < ApplicationController
  UPDATE_SUCCESS = 'シール情報を更新しました。'.freeze

  def index
    validator = NumberSealsidListValidator.new(index_params)
    @query = Leaf.ransack(index_params)

    if validator.valid?
      numbers_sealsid_list = list_query_result
    else
      numbers_sealsid_list = []
      flash[:alert] = validator.errors.full_messages
    end

    @unsealed_list = unsealed_list(numbers_sealsid_list)
  end

  def update
    # The last of the list is always '' by the tag helper,
    # and it needs to be removed!
    @unsealed_list = MultiSealsUpdate.new(update_params)
    @unsealed_list.sealsid_list.pop

    respond_to do |format|
      if @unsealed_list.update_selected_seals
        update_success_format(format)
      else
        update_error_format(format)
      end
    end
  end

  private

  def index_params
    fix_params_q

    params.require(:q)
          .permit(
            :vhiecle_type_eq,
            :valid_flag_eq,
            :contracts_seals_month_eq,
            :contracts_seals_sealed_flag_eq
          )
  end

  def update_params
    params.require(:multi_seals_update)
          .permit(
            :staff_nickname,
            :sealed_date,
            sealsid_list: []
          )
  end

  def fix_params_q
    # Get method has no params, so fixed conditions are inserted.
    if params[:q].nil?
      fix_regular_params
    else
      fix_day_param
    end

    # Pameters below are always same value.
    params[:q][:valid_flag_eq] = true
    params[:q][:contracts_seals_sealed_flag_eq] = false
  end

  def fix_regular_params
    params[:q] = {
      'contracts_seals_month_eq' =>
      Date.current.next_month.beginning_of_month,
      'vhiecle_type_eq' => 1
    }
  end

  def fix_day_param
    # Month form input needs to be translated to Date form for SQL.
    # ex. "2016-05" => "2016-05-01"
    if params[:q][:contracts_seals_month_eq] =~
       %r(\A20[0-9]{2}(/|-)(0[1-9]|1[0-2])\z)
      params[:q][:contracts_seals_month_eq].concat('-01')
    end
  end

  def list_query_result
    @query.result.includes(contracts: :seals)
          .select('number, seals.id as seal_id')
          .order(:number)
  end

  def unsealed_list(numbers_sealsid_list)
    MultiSealsUpdate.new(
      sealsid_list: numbers_sealsid_list,
      sealed_date: Date.current,
      staff_nickname: session[:nickname]
    )
  end

  def update_success_format(format)
    format.html do
      redirect_to menu_path, notice: UPDATE_SUCCESS
    end
    format.json do
      render :index, status: :ok, location: multi_seals_update_path
    end
  end

  def update_error_format(format)
    format.html do
      redirect_to multi_seals_update_path,
                  alert: @unsealed_list.errors.full_messages
    end
    format.json do
      render json: errors, status: :unprocessable_entity
    end
  end
end
