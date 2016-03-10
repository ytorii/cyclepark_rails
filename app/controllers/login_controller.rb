class LoginController < ApplicationController
  # To avoid nonstop loop of checking logined, skip check_login action
  skip_before_action :check_logined
  
  def auth
    staff = Staff.authenticate(params[:nickname], params[:password])
    if staff then
      reset_session
      session[:staff] = staff.id
      session[:nickname] = staff.nickname
      redirect_to params[:referer]
    else
      flash.now[:referer] = params[:referer]
      @error = 'ユーザ名／パスワードが間違っています。'
      p 'ユーザ名／パスワードが間違っています。'
      render 'index'
    end
  end

  def logout
    reset_session
    redirect_to '/login'
  end
end
