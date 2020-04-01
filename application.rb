require './config/initializer.rb'
class Application

  attr_accessor :todoist_project, :todoist, :vimwiki, :api

  def initialize(project:, date: Date.today.strftime("%Y-%m-%d"))
    parse_todoist(project) unless @todoist
    @vimwiki = parse_vimwiki(date) unless @vimwiki
   @api = Todoist::Api.new

  end

  def parse_todoist(project)
    @todoist_project = Todoist.projects.find_by(name: project)
    @todoist = Todos.new(items: @todoist_project.items.map(&:to_todo))
  end

  def parse_vimwiki(date)
    @vimwiki = VimwikiParser.new(date: date)
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
    vimwiki.select do |item| 
      todoist_item todoist.find 
    end
  end

end
