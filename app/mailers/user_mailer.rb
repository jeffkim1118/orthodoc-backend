class UserMailer < ApplicationMailer
    default :from => 'codecove2@gmail.com'

  def activate_account(user)
    @user = user
    mail(to: @user.email, subject: 'Account Activation', content_type: "text/html")
  end

  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to Orthodoc Instrument Manual!', content_type: "text/html")
  end
    # def send_verification_email(user)
    #     @user = user
    #     mail(to: user.email, subject: 'Email Verification')
    # end
end
