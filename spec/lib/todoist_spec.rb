require 'spec_helper'

RSpec.describe Todoist do

  it 'gets all the projects' do
    VCR.use_cassette("todoist_projects") do
      projects = Todoist.projects
      expect(projects.all.map{|p|p.name}).to include("Test Project")
    end
  end

  it 'gets a specific project by name' do
    VCR.use_cassette("todoist_projects") do
      project = Todoist.projects.find_by(name: "Test Project")
      expect(project.id).to eq(2230497753)
    end
  end

  it 'gets a list of todos from a project' do
    VCR.use_cassette('todoist_items') do
      project = Todoist.projects.find_by(name: "Test Project" )
      items = project.items
      expect(items.map(&:content)).to include('Hover over this task & click `(i)` to view its details')
    end
  end
end
