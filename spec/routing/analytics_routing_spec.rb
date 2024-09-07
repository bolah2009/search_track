require "rails_helper"

RSpec.describe "AnalyticsController" do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/analytics").to route_to("analytics#index")
    end
  end
end
