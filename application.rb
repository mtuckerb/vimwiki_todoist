# frozen_string_literal: true

require './config/initializer.rb'

class Application
  attr_accessor :todoist_project, :todoist, :vimwiki, :api

  def initialize(project:, date: Date.today.strftime("%Y-%m-%d"))
    @api = Todoist::Api.new
    parse_todoist(project) unless @todoist
    parse_vimwiki(date) unless @vimwiki
    write_tasks_to_db if DB.is_a?(Sequel::SQLite::Database)
  end

  def reload

  end

  def parse_todoist(project)
    @todoist_project = Todoist.projects.find_by(name: project)
    @todoist = Todos.new(items: @todoist_project&.items&.map(&:to_todo))
  end

  def parse_vimwiki(date)
    @vimwiki = VimwikiParser.new(date: date)
  end

  def sync
    add_missing_to_vimwiki
    add_missing_to_todoist
  end

  def add_missing_to_vimwiki
    new_items = missing_in_vimwiki
    vimwiki.update(new_items)
  end

  def add_missing_to_todoist
    new_items = missing_in_todoist.map { |i| i.to_todoist(todoist_project.id) }
    @api.add_items(new_items)
  end

  def missing_in_todoist
    contents = todoist.map(&:content)
    exclude = contents.size > 0 ? contents : "nothing"
    Task.exclude(content: exclude) 
  end

  def missing_in_vimwiki
    Task.exclude(content: vimwiki.map( &:content ))
  end

  def write_tasks_to_db
    todoist.each { |todo| Task.find_or_create_todo(todo) }
    vimwiki.each { |todo| Task.find_or_create_todo(todo) }
  end
end
