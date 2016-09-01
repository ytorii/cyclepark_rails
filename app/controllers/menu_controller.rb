# Controller for menu page.
class MenuController < ApplicationController
  def index
    @query = Leaf.ransack params[:q]
  end
end
