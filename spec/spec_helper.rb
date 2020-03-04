Bundler.require
require 'rubygems'
require 'bundler/setup'
require 'webmock/rspec'
Dir.glob(File.join('./lib', '**', '*.rb'), &method(:require))
require 'dotenv'
Dotenv.load('.env.test')

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "./spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end
