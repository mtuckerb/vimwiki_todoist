# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application do
  let(:app){ Application.new(project: "Test Project", date: Date.parse("2019-07-02")) }

  it 'gets a list of todos from a project' do
    VCR.use_cassette('todoist_items', record: :once) do
      app.sync
      expect(Task.all.map(&:content)).to include("Hover over this task & click `(i)` to view its details")
    end
  end

  it 'gets a list of todos from vimwiki' do
    VCR.use_cassette('todoist_items') do
      items = app.vimwiki.parse_wiki
      expect(items.map(&:content)).to include("An out of place todo\n  - that has other things")
    end
  end

  it 'creates a collated list of todos' do
    VCR.use_cassette('todoist_collate', record: :once) do
      app.missing_in_todoist
      app.missing_in_vimwiki
      expect( Task.all.map(&:content)).to include("a completed subtask")
    end
  end

  it 'finds vimwiki entries that are not in todoist' do
    VCR.use_cassette('todoist_items',record: :all) do
      app.missing_in_vimwiki
      app.missing_in_todoist
      expect(app.missing_in_todoist.map(&:content)).to include("Help Abby by finding out how to make a Mentor card\n  - Expire\n  - add members on registration > 7 days ago\n  - Last login within 7 days")
    end
  end
  it 'adds missing entries to todoist' do
    VCR.use_cassette('add_to_todoist') do
      app.sync
    end
  end

  end
