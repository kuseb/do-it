class ListChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    list = List.find(params[:id])
    stream_for list
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
