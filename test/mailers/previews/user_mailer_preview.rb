# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
    def send_account_activation_email
        user = User.last
        UserMailer.activate_account(user)
    end

    def send_welcome_email
        user = User.last
        UserMailer.welcome_email(user)
    end
end
