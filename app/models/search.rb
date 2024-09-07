class Search < ApplicationRecord
  validates :query, presence: true
  validates :complete, presence: true
  validates :ip_address, presence: true
  validates :session_id, uniqueness: { case_sensitive: false }

  after_create :clear_associated_cache

  # Fetch the most popular completed searches for a specific IP address
  def self.top_queries_by_ip(ip_address)
    Rails.cache.fetch("top_queries_by_ip_#{ip_address}", expires_in: 5.minutes) do
      where(ip_address:, complete: true)
        .group(:query)
        .order("count(query) DESC")
        .limit(5)
        .pluck(:query, "count(query)")
    end
  end

  # Fetch the most recent completed queries for a specific IP address
  def self.recent_queries_by_ip(ip_address)
    Rails.cache.fetch("recent_queries_by_ip_#{ip_address}", expires_in: 5.minutes) do
      where(ip_address:, complete: true)
        .order(created_at: :desc)
        .limit(10)
        .pluck(:query, :created_at)
    end
  end

  private

  def clear_associated_cache
    Rails.cache.delete("recent_queries_by_ip_#{ip_address}")
    Rails.cache.delete("top_queries_by_ip_#{ip_address}")
  end
end
