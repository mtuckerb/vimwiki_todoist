require 'spec_helper'

RSpec.describe Application do

  let(:app){Application.new(project: "Test Project")}
  it 'gets a list of todos from a project' do
    VCR.use_cassette('todoist_items') do
        puts app.todoist      
    end
  end
end
