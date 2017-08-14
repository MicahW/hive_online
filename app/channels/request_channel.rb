class RequestChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'requests'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
