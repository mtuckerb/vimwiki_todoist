require 'spec_helper'

RSpec.describe VimwikiParser do

  let(:vimwiki){ VimwikiParser.new(vimwiki_dir: './spec/fixtures', date: "2020-01-02") }

  it "parses a wiki file" do
    expect(vimwiki.wiki.size).to  be(14) 
  end

  it 'finds all the todos' do
    expect(vimwiki.parse_wiki).to include({status: " ", todo: "Fix `text_count_not_update_roles` to be `…role'"})
  end
end
