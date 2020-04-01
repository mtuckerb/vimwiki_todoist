# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Todoist do
  it 'gets all the projects' do
    VCR.use_cassette("todoist_projects") do
      projects = Todoist.projects
      expect(projects.all.map(&:name)).to include("Test Project")
    end
  end

  it 'gets a specific project by name' do
    VCR.use_cassette("todoist_projects") do
      project = Todoist.projects.find_by(name: "Test Project")
      expect(project.id).to eq(2_230_497_753)
    end
  end

  it 'gets a list of todos from a project' do
    VCR.use_cassette('todoist_items') do
      project = Todoist.projects.find_by(name: "Test Project" )
      items = project.items
      expect(items.map(&:content)).to include('Hover over this task & click `(i)` to view its details')
    end
  end

  it 'adds an item to todoist project' do
    project = nil
    VCR.use_cassette('todoist_projects') do
      project = Todoist.projects.find_by(name: "Test Project")
    end
    VCR.use_cassette('todoist_add_item') do
      new_item = Todoist::Items::Item.new({ content: "Added by rspec 'adds an item to todoist project'" }, project.id)
      @api = Todoist::Api.new
      @api.add_items(new_item)
      expect(@api.response).to match(":\"ok\"")
    end
  end

end
