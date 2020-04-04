# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Todos do

  before(:each) do
    @todos = Todos.new
    @todo = Todo.new(content: "blerf", order: 1, status: 'checked')
  end

  it 'pushes new items onto the Todos instance' do
    @todos.push @todo
    expect(@todos.first.content).to eq @todo.content
  end

  it 'finds an item by content' do
    @todos.push @todo
    expect(@todos.find_by(content: "blerf").content).to eq("blerf")
  end

  it 'instantiates with an array of todos' do
    new_todos = Todos.new(items: [@todo])
    expect(new_todos.first.content).to eq("blerf")
  end

  it 'instan with an array of hashes' do
    new_todos = Todos.new(items: [
      {content: "New Todo 1", order: 1, status: false},
      {content: "New Todo 2", order: 1, status: false}
    ])
    expect(new_todos.first.content).to eq("New Todo 1")
  end

  it 'instantiates with a single todo' do
    new_todos = Todos.new(items: @todo)
    expect(new_todos.first.content).to eq("blerf")
  end
end
