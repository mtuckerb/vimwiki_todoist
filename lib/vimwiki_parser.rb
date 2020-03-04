require 'date'
class VimwikiParser

  include Enumerable

  attr_accessor :wiki, :todos

  def initialize(date: Date.today.strftime("%Y-%m-%d"))
    vimwiki_dir = ENV["VIMWIKI_DIR"]
    file = File.join(vimwiki_dir, "#{date}.md")
    return unless File.file?(file)
    @wiki = File.readlines(file)
    @todos = parse_wiki unless @todos 
  end

  def each(&block)
    todos.each(&block)
  end

  def parse_wiki
    @todos = []
    wiki.each do |line|
      if matches = line.match(/- \[(.)\] (.*)$/)
        @todos.push({status: matches[1], todo: matches[2]})
      end
    end
    return todos
  end


end
