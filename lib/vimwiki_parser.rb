# frozen_string_literal: true

require 'date'
class VimwikiParser
  include Enumerable

  attr_accessor :file

  def initialize(date: Date.today.strftime("%Y-%m-%d"))
    raise ::ArgumentError, "ENV['VIMWIKI_DIR'] is not set" unless vimwiki_dir = ENV["VIMWIKI_DIR"]

    @file = File.join(vimwiki_dir, "#{date}.md")
    raise ::StandardError, "no file for #{date}" unless File.file?(file)
  end

  def parse_wiki
    wiki = []
    contents = File.read(file)
    matches = contents.scan(/^(\s*) *- \[(.)\] (?:([\s\S]*?)(?=\n\s*- \[.\]|##|^-))/m)
    matches.each_with_index do |match, index|
      todo = OpenStruct.new(content: "#{match[0]}#{match[2].chomp}", status: match[1], order: index)
      wiki.push todo
      Task.find_or_create_todo(todo)
    end
    wiki
  end

  def update
    parse_wiki
    output = []
    File.open(file, "r+") do |file|
      lines = lines = file.each_line.to_a
      todo_start = lines.index{ |l| l =~ /## Daily Todos$/ }
      todo_end = lines.index{ |l| l =~ /## Daily Log$/ }
      ids_to_reject = ((todo_start + 1)..( todo_end - 1 ))
      lines = lines.reject.each_with_index{ |_i, ix| ids_to_reject.include? ix }
      Task.in_order.all.each_with_index do |task, id|
        lines.insert((todo_start + id + 1), format_task(task))
      end
      file.rewind
      lines.each{|l| file.puts l}
    end
  end

  def format_task(item)
    leading_spaces = ""
    # hack to re-indent child tasks until I tackle that
    item.content.index(/[^ ]/).times{ leading_spaces += " " }
    "#{leading_spaces}- [#{item.status ? 'X' : ' '}] #{item.content.strip}"
  end
end
