class UserMailer < ApplicationMailer
  default from: ENV['MAILER_EMAIL']

  def invite_email(current_user, user_receiver, url)
    @user = current_user
    @user_receiver = user_receiver
    @url = url
    mail(to: @user_receiver['email'], subject: 'Invite to fellow driver')
  end
end
