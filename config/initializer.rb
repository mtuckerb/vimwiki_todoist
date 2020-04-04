# frozen_string_literal: true

Bundler.require
require 'dotenv'
require 'sequel'
DB = Sequel.connect('sqlite://db/tasks.db')
if ENV['APP_ENV'] == 'test'
  Dotenv.load("./.env.test")
else
  Dotenv.load("./.env")
end
require 'json'
Dir.glob(File.join('./lib', '**', '*.rb'), &method(:require))
Dir.glob(File.join('./models', '**', '*.rb'), &method(:require))
