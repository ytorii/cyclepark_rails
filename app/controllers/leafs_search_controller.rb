class LeafsSearchController < ApplicationController
  def index
    @query = Leaf.ransack params[:q]
    @leafs = @query.result(distinct: true).includes(:customer)

    respond_to do |format|
      if @leafs.size == 0
        format.html { render '/menu/index', notice: '指定したリーフは存在しません。'  }
        format.json { render json: @leafs.errors, status: :unprocessable_entity }
      elsif @leafs.size == 1
        format.html { redirect_to leaf_path(@leafs.first) }
        format.json { render :show, status: :created, location: @leafs.first }
      else
        format.html { render :index }
        format.json { render :show, status: :created, location: @leafs.first }
      end
    end
  end
end