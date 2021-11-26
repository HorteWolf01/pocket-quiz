class Api::UsersController < ApplicationController
  def index
    render :json => User.all
  end

  def show
    render :json => User.find_by(:id => params[:id])
  end

  def add
    user = User.create!(:name => params[:name], :login => params[:login], :password => params[:password])
    render :json => user
  end

  def update
    user = User.find_by(:id => params[:id])
    user.update!(:name => params[:name]) if params[:name]
    user.update!(:login => params[:login]) if params[:login]
    user.update!(:password => params[:password]) if params[:password]
    render :json => user
  end

  def destroy
    unless user = User.find_by(:id => params[:id])
      render :json => {'status' => 404}
      return
    else
      user.destroy!
      render :json => {'message' => 'Deleted'}
    end
  end

  def auth
    unless @@User
      render :json => {:message => "You're not authorized"}
    else
      render :json => {:apitoken => @@User.apitoken}
    end
  end

  def authored_quizzes
    user = User.find_by(:id => params[:id])
    render :json => {:user =>user, :quizzes => user.authored_quizzes}
  end
end
