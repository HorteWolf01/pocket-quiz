class UsersController < ApplicationController
  skip_before_action :authenticate#, :only => [:new, :create]

  def new
    @user = User.new
  end

  def create
    $user = User.create!(
        params[:user].permit(
          :name,
          :email,
          :password
        )
    )
    session[:confirmation_user_id] = $user.id
    $user.update!(:token => SecureRandom.base64(32).to_s.tr('+=/O0oIl', '')[0..9])
    UserMailer.confirmation_email.deliver_now
    redirect_to '/email_confirmation'
  rescue => e
    flash[:notice] = e.message
    redirect_to '/signup'
  end

  def email_confirmation

  end

  def check_email
    redirect_to '/login' unless session[:confirmation_user_id]
    unless user = User.find_by(:id => session[:confirmation_user_id], :token => params[:confirmation][:token])
      flash[:notice] = "Wrong token"
      return redirect_to '/email_confirmation'
    end
    user.update!(:email_confirmed => true)
    redirect_to '/login'
  end

  def send_email
    redirect_to '/login' unless session[:confirmation_user_id]
    $user = User.find_by(:id => session[:confirmation_user_id])
    p $user
    p $user.token
    UserMailer.confirmation_email.deliver_now
    redirect_to '/email_confirmation'
  end
end
