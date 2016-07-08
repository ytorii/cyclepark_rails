class LeafsSearchController < ApplicationController
  def index
    @query = Leaf.ransack(params[:q])
    ransack_validator = LeafsSearchValidator.new(params[:q])

    respond_to do |format|
      if ransack_validator.invalid?
        format.html { redirect_to menu_path,
          alert: ransack_validator.errors.full_messages }
        format.json { render json: @ransack_validator.errors,
          status: :unprocessable_entity }
      else
        @leafs = @query.result(distinct: true).includes(:customer)

        if @leafs.empty?
          format.html { redirect_to menu_path,
                        alert: ['指定したリーフは存在しません。']  }
          format.json { render json: @leafs.errors,
                        status: :unprocessable_entity }
        elsif @leafs.size == 1
          format.html { redirect_to leaf_path(@leafs.first) }
          format.json { render :show, status: :created,
                        location: @leafs.first }
        else
          format.html { render :index }
          format.json { render :index, status: :created, location: @leafs }
        end
      end
    end
  end
end
