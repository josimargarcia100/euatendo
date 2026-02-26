class QueueChannel < ApplicationCable::Channel
  def subscribed
    stream_from "queue_#{params[:store_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
