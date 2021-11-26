class ApplicationController < ActionController::API
  before_action :authorize

  def authorize
    return @@User = nil unless auth_headers
    case auth_headers[0] 
    when 'Basic'
      token = auth_headers[1]
      login, password = Base64.decode64(token).split(':')
      if User.find_by(:login => login)
        @@User = User.find_by(:login => login).authenticate password
      else
        @@User = nil
      end
    else
      @@User = nil
    end
  end

  private

  def auth_headers
     return nil unless request.headers['Authorization'] 
     request.headers['Authorization'].split(' ')
  end
end
