class Api::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :requires_login, only: [:index, :show, :edit, :update, :destroy]
  before_action :get_user, only: [:show, :edit, :update, :destroy]
  

  def index
    @users = User.all
    render json: UserSerializer.new(@users).serializable_hash[:data].map { |hash| hash[:attributes] }
  end

  def show
    if !authorized(@user)
      render json: { message: 'Off Limits' }, status: :unauthorized
    else
      render json: UserSerializer.new(@user).serializable_hash[:data][:attributes]
    end
    # @user = User.find(params[:id])
  end

  def new
    @user = User.new
    render json: @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.with(user:@user).activate_account(@user).deliver_now
      # render json: { message: 'User created. Verification email sent.' }
      render json: {
        token: get_token(payload(@user.username, @user.id)),
        user: @user
      }
    else
      render json: @user.errors.full_messages
    end
  end

  def verify_email
    user = User.find_by(verification_token: params[:token])
    if user
      user.update(verified: true, verification_token: nil)
      render json: { message: 'Email verified successfully.' }
    else
      render json: { error: 'Invalid verification token.' }, status: :unprocessable_entity
    end
  end

# def show
#   if !authorized(@user)
#     render json: { message: 'Off Limits' }, status: :unauthorized
#   else
#     render json: @user
#   end
# end

def edit
  render json: @user
end



def update
  if @user.update(user_params) && authorized(@user)
    render json: @user
  else
    render json: { message: 'Wrong!' }, status: :unauthorized
  end
end

def destroy
  if authorized(@user)
    render json: @user.destroy
  else
    render json: { message: 'Wrong!' }, status: :unauthorized
  end
end


private
  
  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :password, :email, :bio, :avatar)
  end

  def get_user
    @user = User.find(params[:id])
  end

end
