require "rails_helper"

RSpec.describe SearchChannel do
  let(:ip_address) { "127.0.0.1" }
  let(:session_id) { SecureRandom.uuid }
  let(:query) { "What is the capital of France?" }

  before do
    stub_connection(ip_address:)
    subscribe(ip_address:)
  end

  describe "#subscribed" do
    it "successfully subscribes to the channel" do
      expect(subscription).to be_confirmed
    end

    it "stream from the correct channel" do
      expect(subscription).to have_stream_from("search_channel_#{ip_address}")
    end
  end

  describe "#receive" do
    before do
      allow(Rails.cache).to receive(:delete).with("top_queries_by_ip_#{ip_address}")
      allow(Rails.cache).to receive(:delete).with("recent_queries_by_ip_#{ip_address}")
      allow(Rails.cache).to receive(:delete).with(session_id)
    end

    # and clears the cache
    context "when the query is complete" do
      it "clears the cache" do
        perform(:receive, {
                  query:, ip_address:, session_id:, complete: true
                })

        expect(Rails.cache).to have_received(:delete).with(session_id)
      end

      it "creates a search entry" do
        expect do
          perform(:receive, { query:, ip_address:, session_id:, complete: true })
        end.to change(Search, :count).by(1)
      end
    end

    context "when the query is incomplete" do
      it "writes the query to the cache" do
        allow(Rails.cache).to receive(:write).with(session_id, query, expires_in: 10.minutes)

        perform(:receive, { query:, ip_address:, session_id:, complete: false })
        expect(Rails.cache).to have_received(:write).with(session_id, query, expires_in: 10.minutes)
      end
    end
  end
end
