class AccountActivationsController < ApplicationController
    def edit
        @user = User.find_by(email: params[:email])
        token = get_token(payload(@user.username, @user.id))
        # if @user && !@user.activated? && @user.authenticated?(:activation, token)
        if @user && !@user.activated? && true
          
            @user.activate
            token = get_token(payload(@user.username, @user.id))
            UserMailer.welcome_email(@user)
          
            redirect_to "https://orthodocinstrumentmanual.web.app/login"
        else
            if !@user
                render json: { message: "The user doesn't exist! Please register first."}
            elsif @user.activated?
                UserMailer.welcome_email(@user)
            else
                UserMailer.activate_account(@user)
            end
            redirect_to "https://orthodocinstrumentmanual.web.app/login"
        end
    end
end
