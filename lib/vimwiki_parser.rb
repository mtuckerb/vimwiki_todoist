require 'date'
class VimwikiParser

  include Enumerable

  attr_accessor :wiki, :todos

  def initialize(date: Date.today.strftime("%Y-%m-%d"))
    raise ::ArgumentError, "ENV['VIMWIKI_DIR'] is not set" unless vimwiki_dir = ENV["VIMWIKI_DIR"]
    file = File.join(vimwiki_dir, "#{date}.md")
    raise ::StandardError, "no file for #{date}" unless  File.file?(file)
    @wiki = File.readlines(file)
    @todos = parse_wiki unless @todos 
    raise ::StandardError, "No todos Parsed" unless todos.count > 0
  end

  def each(&block)
    todos.each(&block)
  end

  def parse_wiki
    @todos = Todos.new
    wiki.each_with_index do |line,index|
      if matches = line.match(/- \[(.)\] (.*)$/)
        @todos.push(Todo.new({status: matches[1], content: matches[2], order: index}))
      end
    end
    todos
  end

  def to_ary
    todos
  end

end
