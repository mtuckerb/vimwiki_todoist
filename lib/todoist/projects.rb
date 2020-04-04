class Todoist::Projects 
  attr_accessor :all

  include Enumerable

  def initialize
    @api ||= Todoist::Api.new
    projects unless @all
  end

  def each(&block)
    @all.each(&block)
  end

  def projects
    @all = @api.get_projects.map{|p| Project.new(p)}
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

  def to_ary
    @all
  end

end


class Todoist::Projects::Project
  attr_accessor :project, :items

  def initialize(project)
    @api = Todoist::Api.new
    @project = project
  end

  def items
    options =  { project_id: id }
    results = @api.post(resource: "projects/get_data", options: options)
    @items = Todoist::Items.new(JSON.parse(results).dig("items"), id)
  end

  def method_missing(method, *args)
    return project.dig(method.to_s)
  end
end
