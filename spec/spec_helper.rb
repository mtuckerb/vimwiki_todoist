require 'rubygems'
require 'bundler/setup'
require './lib/vimwiki_parser.rb'
require './lib/todoist.rb'
require 'webmock/rspec'
Bundler.require

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "./spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end
