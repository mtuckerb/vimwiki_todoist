# frozen_string_literal: true

require 'spec_helper'

RSpec.describe VimwikiParser do
  let(:vimwiki){ VimwikiParser.new(date: Date.parse("2019-07-02")) }
  context 'non-destructive' do

    it "parses a wiki file" do
      vimwiki.parse_wiki
      expect(Task.all.count).to eq(5)
    end

    it "does not parse non todo lines" do
      vimwiki.parse_wiki
      expect(Task.all).not_to include("Lingohub merge")
    end

    it 'finds all the todos' do
      vimwiki.parse_wiki
      expect(Task.all.map(&:content)).to include("An out of place todo\n  - that has other things")
    end
  end

  context "destructive tests" do
    before(:each) do
      `cp ./spec/fixtures/2019-07-02.md ./spec/fixtures/2019-07-02.bak`
    end

    after(:each) do
      sleep 5
      `mv ./spec/fixtures/2019-07-02.bak ./spec/fixtures/2019-07-02.md`
      vimwiki.parse_wiki
    end

    it 'inserts changed todos into vimwiki' do
      new_tasks = Task.create(content: "A new task 💥", order: 1, status: nil)
      vimwiki.update
      wiki = vimwiki.parse_wiki
      expect(wiki[1].content).to eq("A new task 💥")
    end

    it 'inserts changed todos with high order into vimwiki' do
      new_task= Task.create(content: "The LAST task 🛑", order: 6, status: nil )
      vimwiki.update
      wiki = vimwiki.parse_wiki
      expect(wiki[5].content).to eq(new_task.content)
      expect(wiki.select{|t| t.content == new_task.content}.count).to eq(1)
    end
  end
end
