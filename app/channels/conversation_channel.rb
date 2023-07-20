# mount ActionCable.server => "/cable"
class ConversationChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    # conversation = Conversation.find(params[:id])
    # stream_from "ConversationChannel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
