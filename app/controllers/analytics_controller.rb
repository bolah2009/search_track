class AnalyticsController < ApplicationController
  include ActionView::Helpers::DateHelper

  def index
    ip_address = request.remote_ip
    @top_queries = Search.top_queries_by_ip(ip_address)
    @recent_queries = Search.recent_queries_by_ip(ip_address)
    # Format the created_at timestamp using time_ago_in_words
    @recent_queries = @recent_queries.map do |query, created_at|
      [query, "#{time_ago_in_words(created_at)} ago"]
    end
    render json: {
      top_queries: @top_queries,
      recent_queries: @recent_queries
    }
  end
end
