# Controller for login
class LoginController < ApplicationController
  # To avoid nonstop loop of checking logined, skip check_login action
  skip_before_action :check_logined

  # It just shows the login page.
  def index
  end

  def auth
    staff = Staff.authenticate(params[:nickname], params[:password])

    if staff
      success_login(staff)
    else
      fail_login
    end
  end

  def logout
    reset_session
    redirect_to '/login'
  end

  private

  def success_login(staff)
    reset_session
    session[:staff] = staff.id
    session[:nickname] = staff.nickname
    redirect_to referer_params
  end

  def fail_login
    flash.now[:referer] = params[:referer]
    @error = 'ユーザ名／パスワードが間違っています。'
    render 'index'
  end

  # TODO: referer URL should be white listed
  def referer_params
    params.require(:referer)
  end
end
