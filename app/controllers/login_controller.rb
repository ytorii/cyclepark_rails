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
    redirect_to validate_referer(params[:referer])
  end

  def fail_login
    flash.now[:referer] = params[:referer]
    @error = 'ユーザ名／パスワードが間違っています。'
    render 'index'
  end

  def validate_referer(url)
    begin
      # TODO: Validate referer with RegExp.
      if path =  URI.parse(url).path
        path
      end
    rescue URI::InvalidURIError
      '/login'
    end
  end
end
