# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application do
  let(:app){ Application.new(project: "Test Project", date: Date.parse("2019-07-02")) }

  it 'gets a list of todos from a project' do
    VCR.use_cassette('todoist_items', record: :all) do
      items = app.todoist
      expect(items.map(&:content)).to include("Hover over this task & click `(i)` to view its details")
    end
  end

  it 'gets a list of todos from vimwiki' do
    VCR.use_cassette('todoist_items') do
      items = app.vimwiki
      expect(items.map(&:content)).to include("An out of place todo")
    end
  end

  it 'creates a collated list of todos' do
    VCR.use_cassette('todoist_collate') do
      expect( app.todoist.map(&:content)).to include("a completed subtask")
    end
  end

  it 'finds vimwiki entries that are not in todoist' do
    VCR.use_cassette('todoist_items') do
      expect(app.missing_in_todoist.map(&:content)).to include("Help Abby by finding out how to make a Mentor card")
    end
  end
  it 'adds missing entries to todoist' do
    VCR.use_cassette('add_to_todoist') do
      app.sync_to_todoist
    end
  end

  it 'identifies status changes between projects' do
    VCR.use_cassette('updated_items') do
      skip
      expect(app.changed_between_projects).to include
    end
  end
end
