require 'spec_helper'

RSpec.describe VimwikiParser do

  let(:vimwiki){ VimwikiParser.new(date: Date.parse("2019-07-02")) }

  it "parses a wiki file" do
    expect(vimwiki.todos.count).to  eq(5) 
  end

  it "does not parse non todo lines" do
    expect(vimwiki.todos).not_to include("Lingohub merge")
  end

  it 'finds all the todos' do
    expect(vimwiki.todos.map(&:content)).to include("An out of place todo")
  end
end
