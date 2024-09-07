require "rails_helper"

RSpec.describe "Analytics" do
  include ActionView::Helpers::DateHelper

  let(:ip_address) { "127.0.0.1" }
  let(:top_queries) { [["What is the capital of France?", 3], ["Who won the World Cup?", 2]] }
  let(:recent_queries) do
    [["What is the capital of France?", 5.minutes.ago], ["Who won the World Cup?", 10.minutes.ago]]
  end
  let(:formatted_recent_queries) do
    recent_queries.map { |query, created_at| [query, "#{time_ago_in_words(created_at)} ago"] }
  end

  let(:json_response) { response.parsed_body }

  before do
    allow(Search).to receive(:top_queries_by_ip).with(ip_address).and_return(top_queries)
    allow(Search).to receive(:recent_queries_by_ip).with(ip_address).and_return(recent_queries)
  end

  describe "GET /analytics" do
    before { get analytics_path, headers: { "REMOTE_ADDR" => ip_address } }

    it "returns a successful response" do
      expect(response).to have_http_status(:success)
    end

    it "assigns the top queries for the IP address" do
      expect(json_response["top_queries"]).to eq(top_queries)
    end

    it "assigns and formats the recent queries for the IP address" do
      expect(json_response["recent_queries"]).to eq(formatted_recent_queries)
    end
  end
end
