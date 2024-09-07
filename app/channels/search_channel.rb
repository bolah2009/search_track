class SearchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "search_channel_#{params[:ip_address]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    query = data["query"]
    ip_address = data["ip_address"]
    session_id = data["session_id"]
    complete = data["complete"]

    if complete
      Search.create(session_id:, query:, ip_address:, complete: true)
      # Clear the cache after saving to the database
      Rails.cache.delete(session_id)
    else
      # Replace the previous query with the current one or add a new query in the cache
      Rails.cache.write(session_id, query, expires_in: 10.minutes)
    end
  end
end
