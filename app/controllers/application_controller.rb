class ApplicationController < ActionController::Base
  before_action :authenticate

  def authenticate
    unless $user = User.find_by(:id => session[:user_id])
      $user = nil
      redirect_to '/login'
    end
  end
end
