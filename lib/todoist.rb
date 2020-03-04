# frozen_string_literal: true

class Todoist
  require_relative './todoist/projects'
  require_relative './todoist/items'
  require_relative './todoist/api'
  API_KEY=ENV['API_KEY']


  def self.projects
    Todoist::Projects.new
  end


end
