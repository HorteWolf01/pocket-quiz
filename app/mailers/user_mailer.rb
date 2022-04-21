class UserMailer < ApplicationMailer
  def confirmation_email
    mail(:to => $user.email, :subject => "Registration in \"Pocket quiz 2\"")
  end
end
