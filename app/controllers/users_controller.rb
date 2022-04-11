class UsersController < ApplicationController
  skip_before_action :authenticate, :only => [:new, :create]

  def new
    @user = User.new
  end

  def create
    User.create!(
        params[:user].permit(
          :name,
          :email,
          :password
        )
    )
      flash[:notice] = 'User craeted.'
      redirect_to '/quizzes'
  rescue => e
    flash[:notice] = e.message
    redirect_to '/signup'
  end
end
