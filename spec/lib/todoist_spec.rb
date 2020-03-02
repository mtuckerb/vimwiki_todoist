require 'spec_helper'


RSpec.describe Todoist do

  let(:vimwiki){ VimwikiParser.new(vimwiki_dir: './spec/fixtures', date: "2020-01-02") }

  it 'gets all the projects' do
    VCR.use_cassette("todoist_projects") do
      expect(Todoist.projects.dig("projects").map{|p|p["name"]}).to include("Welcome 👋")
    end
  end
end
