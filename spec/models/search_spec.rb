require "rails_helper"

RSpec.describe Search do
  describe "validations" do
    it { is_expected.to validate_presence_of(:query) }
    it { is_expected.to validate_presence_of(:ip_address) }
    it { is_expected.to validate_presence_of(:complete) }
    it { is_expected.to validate_uniqueness_of(:session_id).ignoring_case_sensitivity }
  end

  describe "after_create callback" do
    let(:search) { create(:search) }
    let(:top_queries_cache_key) { "top_queries_by_ip_#{search.ip_address}" }
    let(:recent_queries_cache_key) { "recent_queries_by_ip_#{search.ip_address}" }

    before do
      allow(Rails.cache).to receive(:delete).with(top_queries_cache_key)
      allow(Rails.cache).to receive(:delete).with(recent_queries_cache_key)
    end

    it "clears the recent queries by ip cache after creating a search" do
      search.run_callbacks(:create)

      expect(Rails.cache).to have_received(:delete).with(recent_queries_cache_key)
    end

    it "clears the top queries by ip cache after creating a search" do
      search.run_callbacks(:create)

      expect(Rails.cache).to have_received(:delete).with(top_queries_cache_key)
    end
  end

  describe ".top_queries_by_ip" do
    let(:ip_address) { "127.0.0.1" }

    before do
      create_list(:search, 3, ip_address:, complete: true, query: "query1")
      create(:search, ip_address:, complete: true, query: "query2")
    end

    it "returns the top 5 queries for a given IP address" do
      top_queries = described_class.top_queries_by_ip(ip_address)

      expect(top_queries).to eq([["query1", 3], ["query2", 1]])
    end

    it "caches the result for 5 minutes" do
      allow(Rails.cache).to receive(:fetch).with("top_queries_by_ip_#{ip_address}",
                                                 expires_in: 5.minutes).and_call_original
      described_class.top_queries_by_ip(ip_address)

      expect(Rails.cache).to have_received(:fetch).with("top_queries_by_ip_#{ip_address}",
                                                        expires_in: 5.minutes)
    end
  end

  describe ".recent_queries_by_ip" do
    let(:ip_address) { "127.0.0.1" }
    let(:query_1_created_at) { Time.parse("2024-09-06 11:45:12.194572000 +0000") }
    let(:query_2_created_at) { Time.parse("2024-09-05 11:45:12.179815000 +0000") }

    before do
      create(:search, ip_address:, complete: true, query: "query1", created_at: query_1_created_at)
      create(:search, ip_address:, complete: true, query: "query2", created_at: query_2_created_at)
    end

    it "returns the 10 most recent queries for a given IP address" do
      recent_queries = described_class.recent_queries_by_ip(ip_address)

      expect(recent_queries).to eq([["query1", query_1_created_at],
                                    ["query2", query_2_created_at]])
    end

    it "caches the result for 5 minutes" do
      allow(Rails.cache).to receive(:fetch).with("recent_queries_by_ip_#{ip_address}",
                                                 expires_in: 5.minutes).and_call_original
      described_class.recent_queries_by_ip(ip_address)

      expect(Rails.cache).to have_received(:fetch).with("recent_queries_by_ip_#{ip_address}",
                                                        expires_in: 5.minutes)
    end
  end
end
