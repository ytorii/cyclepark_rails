# Common process for all controllers.
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_logined

  private

  def check_logined
    if session[:staff]
      begin
        @staff = Staff.find(session[:staff])
      rescue ActiveRecord::RecordNotFound
        # reset_session deletes all sessions!
        redirect_to_login
      end
    else
      redirect_to_login
    end
  end

  def redirect_to_login
    session[:staff] = nil
    flash[:referer] = request.fullpath
    redirect_to controller: :login, action: :index
  end
end
