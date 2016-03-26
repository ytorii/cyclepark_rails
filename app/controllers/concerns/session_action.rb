module SessionAction extend ActiveSupport::Concern

  def check_admin
    unless Staff.find(session[:staff]).admin_flag
      flash[:referer] = request.fullpath
      flash[:error] = '管理者としてログインして下さい。'
      redirect_to controller: :login, action: :index
      return
    end
  end
end
