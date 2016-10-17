# Controller for index and update multi seals
class MultiSealsUpdateController < ApplicationController
  UPDATE_SUCCESS = 'シール情報を更新しました。'.freeze

  # Routed from GET index
  def index
    @search = NumberSealsidListSearch.new
    @list = @search.result
    @multi_seals_update = multi_seals_update_params
  end

  # Routed from POST index
  def search
    # Setting values for @search, @multi_seals_update
    search_instance_values

    respond_to do |format|
      if @search.valid?
        @list = @search.result
      else
        @list = []
        flash.now[:alert] = @search.errors.full_messages
      end
      format.html { render :index }
    end
  end

  def update
    # Setting values for @multi_seals_update
    @multi_seals_update = MultiSealsUpdate.new(update_params)

    respond_to do |format|
      if @multi_seals_update.update_selected_seals
        update_success_format(format)
      else
        update_error_format(format)
      end
    end
  end

  private

  def search_instance_values
    @search = NumberSealsidListSearch.new(search_params)
    @multi_seals_update = multi_seals_update_params
  end

  def multi_seals_update_params
    MultiSealsUpdate.new(
      sealed_date: Date.current,
      staff_nickname: session[:nickname]
    )
  end

  def search_params
    params.require(:number_sealsid_list_search)
          .permit(:vhiecle_type, :month, :sealed_flag)
  end

  def update_params
    params.require(:multi_seals_update)
          .permit(:staff_nickname, :sealed_date, sealsid_list: [])
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
                  alert: @multi_seals_update.errors.full_messages
    end
    format.json do
      render json: errors, status: :unprocessable_entity
    end
  end
end
