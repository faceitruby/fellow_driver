class UserMailer < ApplicationMailer
  default from: ENV['MAILER_EMAIL']

  def invite_email(name, user_receiver, url)
    @name = name
    @user_receiver = user_receiver
    @url = url
    mail(to: @user_receiver['email'], subject: 'Invite to fellow driver')
  end
end
