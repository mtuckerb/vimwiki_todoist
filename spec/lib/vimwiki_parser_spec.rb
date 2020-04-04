# frozen_string_literal: true

require 'spec_helper'

RSpec.describe VimwikiParser do
  let(:vimwiki){ VimwikiParser.new(date: Date.parse("2019-07-02")) }
  context 'non-destructive' do

    it "parses a wiki file" do
      expect(vimwiki.todos.count).to eq(5)
    end

    it "does not parse non todo lines" do
      expect(vimwiki.todos).not_to include("Lingohub merge")
    end

    it 'finds all the todos' do
      expect(vimwiki.todos.map(&:content)).to include("An out of place todo")
    end
  end

  context "destructive tests" do
    before(:each) do
      `cp ./spec/fixtures/2019-07-02.md ./spec/fixtures/2019-07-02.bak`
    end

    after(:each) do
      `mv ./spec/fixtures/2019-07-02.bak ./spec/fixtures/2019-07-02.md`
      vimwiki.parse_wiki
    end

    it 'inserts changed todos into vimwiki' do
      new_tasks = Todos.new(items: [{ content: "A new task 💥", order: 1, staus: nil }] )
      vimwiki.update(new_tasks)
      vimwiki.parse_wiki
      expect(vimwiki[1].content).to eq("A new task 💥")
    end

    it 'inserts changed todos with high order into vimwiki' do
      new_tasks = Todos.new(items: [{ content: "The LAST task 🛑", order: 6, staus: nil }] )
      vimwiki.update(new_tasks)
      vimwiki.parse_wiki
      expect(vimwiki[4].content).to eq("The LAST task 🛑")
      expect(vimwiki.select{|t| t.content == "The LAST task 🛑"}.count).to eq(1)
    end
  end
end
