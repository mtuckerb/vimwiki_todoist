require './config/initializer.rb'
class Application

  attr_accessor :todoist_project, :todoist, :vimwiki, :api

  def initialize(project:, date: Date.today.strftime("%Y-%m-%d"))
    parse_todoist(project) unless @todoist
    parse_vimwiki(date) unless @vimwiki
    @api = Todoist::Api.new
  end

  def parse_todoist(project)
    @todoist_project = Todoist.projects.find_by(name: project)
    @todoist = Todos.new(items: @todoist_project.items.map(&:to_todo))
  end

  def parse_vimwiki(date)
    @vimwiki = VimwikiParser.new(date: date).todos
  end

  def sync_to_todoist
    #update_changed_to_todoist 
    add_missing_to_todoist
  end

  def add_missing_to_todoist
    new_items = missing_in_todoist.map { |i| i.to_todoist(todoist_project.id)}
    @api.add_items(new_items)
  end

  def missing_in_todoist
    vimwiki.select{|item| !todoist.include?(item.content)} 
  end

  def changed_between_projects
   a = vimwiki.select do |item| 
      todoist.find_by(content: item&.content)&.status != item.status
    end
   b = todoist.select do |item|
     vimwiki.find_by(content: item&.content)&.status != item.status
   end
   a + b
  end

end
