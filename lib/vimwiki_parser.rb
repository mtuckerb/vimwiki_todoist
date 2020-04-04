# frozen_string_literal: true

require 'date'
class VimwikiParser
  include Enumerable

  attr_accessor :wiki, :todos, :file

  def initialize(date: Date.today.strftime("%Y-%m-%d"))
    raise ::ArgumentError, "ENV['VIMWIKI_DIR'] is not set" unless vimwiki_dir = ENV["VIMWIKI_DIR"]
    @file = File.join(vimwiki_dir, "#{date}.md")
    raise ::StandardError, "no file for #{date}" unless File.file?(file)
    @todos = parse_wiki
    raise ::StandardError, "No todos Parsed" unless todos.count > 0
  end

  def each(&block)
    todos.each(&block)
  end

  def sort(&block)
    todos.sort(&block)
  end

  def to_a
    todos
  end

  def [] index
    @todos[index]
  end

  def parse_wiki
    @wiki = File.readlines(file)
    wiki.each_with_index do |line, index|
      if matches = line.match(/- \[(.)\] (.*)$/)
        Task.create(status: matches[1], content: matches[2], order: index)
      end
    end
    todos
  end

  def update(tasks)
    tasks = Task.all.sort(&:order)
    counter = 0 
    its_on = 0
    output = []
    wiki.each do |line|
      if line.match(/## Daily Log$/)
        its_on = 0
        # if we get the the end, quickly put all of the remaing tasks on the
        # list
        tasks.select{|t| t.order > counter || !t.order.is_a?(Integer) }.each{|t| output.push format_task(t)}
      end
      if its_on == 1
        if (this_task = tasks.find{ |t| t.order == counter }) && is_todo_line(line)
          output.push format_task(this_task)
          counter += 1
        else
          # only increment after a task
          counter += 1 if is_todo_line(line)
        end
      end
      output.push line
      its_on = 1 if line.match(/## Daily Todos$/)
    end
    new_wiki = File.open(file, "w"){|f| output.each{|l| f.puts l}}
  end

  def format_task(item)
    "- [#{item.status ? 'X' : ' '}] #{item.content}"
  end

  def is_todo_line(line)
    line.match(/\s*- \[.?\]/)
  end

  def to_ary
    todos
  end
end
