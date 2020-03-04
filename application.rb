require './config/initializer.rb'
class Application

  attr_accessor :todoist_project, :todoist, :vimwiki

  def initialize(project:)
    @todoist = parse_todoist(project) unless @todoist
    @vimwiki = parse_vimwiki unless @vimwiki 
  end

  def parse_todoist(project)
    Todoist.projects.find_by(name: project)
  end

  def parse_vimwiki
    VimwikiParser.new()
  end

end
