require 'bundler/setup'
Bundler.require
require 'dotenv/load'
require 'json'
Dir.glob(File.join('./lib', '**', '*.rb'), &method(:require))
