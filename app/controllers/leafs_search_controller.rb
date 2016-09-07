# Controller for index leaf search results
class LeafsSearchController < ApplicationController
  def index
    @ransack_validator = LeafsSearchValidator.new(search_params)
    @query = Leaf.ransack(search_params)

    respond_to do |format|
      if @ransack_validator.valid?
        @leafs = @query.result(distinct: true).includes(:customer)
        allocate_result_format(format)
      else
        validation_error_format(format)
      end
    end
  end

  private

  def allocate_result_format(format)
    if @leafs.empty?
      # No leafs found.
      empty_result_format(format)
    elsif @leafs.size == 1
      # Only one leaf found.
      single_result_format(format)
    else
      # Several leafs found.
      multi_results_format(format)
    end
  end

  def empty_result_format(format)
    format.html do
      redirect_to menu_path, alert: ['指定したリーフは存在しません。']
    end
    format.json do
      render json: @leafs.errors, status: :unprocessable_entity
    end
  end

  def single_result_format(format)
    format.html { redirect_to leaf_path(@leafs.first) }
    format.json do
      render :show, status: :created, location: @leafs.first
    end
  end

  def multi_results_format(format)
    format.html { render :index }
    format.json { render :index, status: :created, location: @leafs }
  end

  def validation_error_format(format)
    format.html do
      redirect_to menu_path, alert: @ransack_validator.errors.full_messages
    end
    format.json do
      render json: @ransack_validator.errors, status: :unprocessable_entity
    end
  end

  # strong parameters
  def search_params
    #if params[:q] && name_search_param
    if params.dig(:q, :customer_first_name_or_customer_last_name_cont)
      params.require(:q).permit(
        :customer_first_name_or_customer_last_name_cont
      )
    else
      params.require(:q).permit(
        :vhiecle_type_eq, :number_eq, :valid_flag_eq
      )
    end
  end
end
