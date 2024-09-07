require "rails_helper"

RSpec.describe "Searches" do
  let(:ip_address) { "127.0.0.1" }
  let(:top_queries) { [["What is the capital of France?", 3], ["Who won the World Cup?", 2]] }
  let(:recent_queries) do
    [["What is the capital of France?", 5.minutes.ago], ["Who won the World Cup?", 10.minutes.ago]]
  end

  before do
    allow(Search).to receive(:top_queries_by_ip).with(ip_address).and_return(top_queries)
    allow(Search).to receive(:recent_queries_by_ip).with(ip_address).and_return(recent_queries)
  end

  describe "GET /searches" do
    before { get searches_path, headers: { "REMOTE_ADDR" => ip_address } }

    it "returns a successful response" do
      expect(response).to have_http_status(:success)
    end

    it "assigns the top queries for the IP address" do
      expect(assigns(:top_queries)).to eq(top_queries)
    end

    it "assigns the recent queries for the IP address" do
      expect(assigns(:recent_queries)).to eq(recent_queries)
    end

    it "retrieves the correct IP address" do
      expect(request.remote_ip).to eq(ip_address)
    end
  end
end
