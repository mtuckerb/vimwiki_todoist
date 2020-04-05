# frozen_string_literal: true

require './config/initializer.rb'

class Application
  attr_accessor :todoist_project, :vimwiki, :api

  def initialize(project:, date: Date.today.strftime("%Y-%m-%d"))
    @api = Todoist::Api.new
    parse_todoist(project) unless @todoist
    @vimwiki = VimwikiParser.new(date: date)
  end

  def reload; end

  def parse_todoist(project)
    @todoist_project = Todoist.projects.find_by(name: project)
    @todoist_project&.items&.each do |item|
      item.to_task
    end
  end

  def sync
    add_missing_to_vimwiki
    add_missing_to_todoist
  end

  def add_missing_to_vimwiki
    new_items = missing_in_vimwiki
    vimwiki.update
  end

  def add_missing_to_todoist
    new_items = missing_in_todoist.map { |i| i.to_todoist(todoist_project.id) }
    @api.add_items(new_items)
  end

  def missing_in_todoist
    contents = todoist_project.items.map(&:content)
    exclude = !contents.empty? ? contents : "nothing"
    Task.in_order.exclude(content: exclude).all
  end

  def missing_in_vimwiki
    exclude = vimwiki.parse_wiki.map{|e| e.content}
    Task.in_order.exclude(content: exclude ).all
  end

end
