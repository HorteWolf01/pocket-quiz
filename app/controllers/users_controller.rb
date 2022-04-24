class UsersController < ApplicationController
  skip_before_action :authenticate,
    :except => [:index, :show, :update, :destroy, :switch_admin]#:only => [:new, :create]
  skip_before_action :verify_authenticity_token, :only => [:destroy, :switch_admin]

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
  rescue => e
    flash[:notice] = e.message
  end

  def check_email
    redirect_to '/login' unless session[:confirmation_user_id]
    unless user = User.find_by(:id => session[:confirmation_user_id], :token => params[:confirmation][:token])
      flash[:notice] = "Wrong token"
      return redirect_to '/email_confirmation'
    end
    user.update!(:email_confirmed => true)
    redirect_to '/login'
  rescue => e
    flash[:notice] = e.message
  end

  def send_email
    redirect_to '/login' unless session[:confirmation_user_id]
    $user = User.find_by(:id => session[:confirmation_user_id])
    p $user
    p $user.token
    UserMailer.confirmation_email.deliver_now
    redirect_to '/email_confirmation'
  rescue => e
    flash[:notice] = e.message
  end

  def index
    render :json => {:message => 'Only for admins'}, :status => :forbidden unless $user.admin
    @users = User.all
  rescue => e
    flash[:notice] = e.message
  end

  def show
    render :json => {:message => 'Only for admins'}, :status => :forbidden unless $user.admin
    render :json => {:message => 'Not found'}, 
      :status => :not_found unless @user = User.find_by(:id => params[:id])
  rescue => e
    flash[:notice] = e.message
  end

  def update
    render :json => {:message => 'Only for admins'}, :status => :forbidden unless $user.admin
    render :json => {:message => 'Not found'},
      :status => :not_found unless user = User.find_by(:id => params[:id])
    user.update!(
      params[:user].permit(
        :admin,
        :name
      )
    )
    redirect_to "/users"
  rescue => e
    flash[:notice] = e.message
  end

  def destroy
    render :json => {:message => 'Only for admins'}, :status => :forbidden unless $user.admin
    render :json => {:message => 'Not found'},
      :status => :not_found unless user = User.find_by(:id => params[:id])
    user.destroy!
    redirect_to "/users"
  rescue => e
    flash[:notice] = e.message
  end

  def switch_admin
    p 'test'
    render :json => {:message => 'Only for admins'}, :status => :forbidden unless $user.admin
    render :json => {:message => 'Not found'},
      :status => :not_found unless @user = User.find_by(:id => params[:id])
    @user.update!( :admin => !@user.admin )
    redirect_to "/users"
  rescue => e
    flash[:notice] = e.message
  end
end
