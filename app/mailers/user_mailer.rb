class UserMailer < ApplicationMailer
  def welcome_email
    mail(:to => $user.email, :subject => "Welcome to Pocket Quiz 2")
  end
end
