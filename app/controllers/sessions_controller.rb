class SessionsController < ApplicationController   
  skip_before_action :authenticate, :only => [:new, :create]

  def new
    return destroy if session[:user_id]
  rescue => e
    flash[:notice] = e.message
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
  if user && user.authenticate(params[:session][:password]) 
    unless user.email_confirmed
      session[:confirmation_user_id] = user.id
      return redirect_to '/email_confirmation'
    end
    session[:user_id] = user.id
    flash[:notice] = "Logged in successfully."
    authenticate
    redirect_to '/quizzes'
  else
    flash.now[:alert] = "There was something wrong with your login details."
    render 'new'
  end
  rescue => e
    flash[:notice] = e.message
end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to '/quizzes'
  rescue => e
    flash[:notice] = e.message
  end

  def email
    $url = "#{request.host_with_port}/login"
    UserMailer.welcome_email.deliver_now
  rescue => e
    flash[:notice] = e.message
  end
end
