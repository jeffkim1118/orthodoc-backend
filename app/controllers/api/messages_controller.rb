class Api::MessagesController < ApplicationController
  # before_action :load_user
  before_action :set_message, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token

  # GET /messages or /messages.json
  def index
    @messages = Message.all
    render json: @messages
  end

  # GET /messages/1 or /messages/1.json
  def show
    @messages = @user.messages.find(params[:id])
    render json: @message
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages or /messages.json
  def create
    # @conversation = Conversation.find(params[:conversation_id])
    # @message = @conversation.messages.new(message_params)
    @message = Message.new(message_params)
    if @message.save
      # ActionCable.server.broadcast 'messages',
      #   message: message.content,
      ActionCable.server.broadcast 'MessagesChannel', @message
      render json: { message: @message }
    else
      render "WRONG MESSAGE"
    end
    # @message = Message.create(message_params)
    # @conversation = Conversation.find(@message[:conversation_id])

    # ConversationChannel.broadcast_to(@conversation, @message)
    # render json: @message
    # @message = Message.new(message_params)

    # respond_to do |format|
    #   if @message.save
    #     format.html { redirect_to message_url(@message), notice: "Message was successfully created." }
    #     format.json { render :show, status: :created, location: @message }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @message.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to message_url(@message), notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    def load_user
      @user = User.find(params[:user_id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:username, :content, :conversation_id, :user_id)
    end
end
