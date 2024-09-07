require "rails_helper"

RSpec.describe "searches/index" do
  let(:top_queries) { [["What is the capital of France?", 3], ["Who won the World Cup?", 2]] }
  let(:recent_queries) do
    [["What is the capital of France?", 5.minutes.ago], ["Who won the World Cup?", 10.minutes.ago]]
  end

  before do
    assign(:top_queries, top_queries)
    assign(:recent_queries, recent_queries)
    render
  end

  it "displays the search box" do
    expect(rendered).to have_field("Search", type: "search")
  end

  it "displays the search analytics heading" do
    expect(rendered).to have_css("h3", text: "Search Analytics")
  end

  it "displays the top queries section caption" do
    expect(rendered).to have_css("caption", text: "List of top queries")
  end

  it "displays the top queries section qeuries" do
    top_queries.each do |data|
      expect(rendered).to have_css("td", text: data[0])
    end
  end

  it "displays the top queries section counts" do
    top_queries.each do |data|
      expect(rendered).to have_css("td", text: data[1].to_s)
    end
  end

  it "displays the recent queries section caption" do
    expect(rendered).to have_css("caption", text: "List of recent searches")
  end

  it "displays the recent queries section query" do
    recent_queries.each do |data|
      expect(rendered).to have_css("td", text: data[0])
    end
  end

  it "displays the recent queries section time created" do
    recent_queries.each do |data|
      expect(rendered).to have_css("td", text: "#{time_ago_in_words(data[1])} ago")
    end
  end

  context "when there are no recent queries" do
    let(:recent_queries) { [] }

    it "hides the recent queries section" do
      expect(rendered).to have_css("#recent-queries-section.hidden")
    end
  end

  context "when there are no top queries" do
    let(:top_queries) { [] }

    it "hides the top queries section" do
      expect(rendered).to have_css("#top-queries-section.hidden")
    end
  end
end
