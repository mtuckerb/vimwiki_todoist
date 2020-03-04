class Todoist::Projects 
  attr_accessor :all

  include Enumerable

  def initialize
    projects unless @all
  end

  def each(&block)
    @all.each(&block)
  end

  def projects
    options = {resource_types: '["projects"]', sync_token: "*" }
    results = Todoist::Api.post(resource: "sync", options:  options)
    @all = JSON.parse(results).dig("projects").map{|p| Project.new(p)}
  end

  def where(args)
    results = all
    args.each do |k,v|
      results.reject!{|p| p.send(k.to_sym) != v}
    end
    results
  end

  def find_by(args)
    where(args).first
  end

  def method_missing(method, *args)
    return all.dig(method.to_s)
  end

  def to_a
    @all
  end

end


class Todoist::Projects::Project
  attr_accessor :project

  def initialize(project)
    @project = project
  end

  def items
    options =  { project_id: id }
    #results = HTTParty.post("#{ENV['TODOIST_BASE_URI']}/projects/get_data", options).response.body
    results = Todoist::Api.post(resource: "projects/get_data", options: options)
    @all = Todoist::Items.new(JSON.parse(results).dig("items"))
  end

  def method_missing(method, *args)
    return project.dig(method.to_s)
  end
end
