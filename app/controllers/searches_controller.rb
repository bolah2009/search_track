class SearchesController < ApplicationController
  def index
    ip_address = request.remote_ip
    @top_queries = Search.top_queries_by_ip(ip_address)
    @recent_queries = Search.recent_queries_by_ip(ip_address)
  end
end
