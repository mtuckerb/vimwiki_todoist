Bundler.require
require 'dotenv'
if APP_ENV == 'test'
  Dotenv.load("./.env.test")
else
  Dotenv.load("./.env")
end
require 'json'
Dir.glob(File.join('./lib', '**', '*.rb'), &method(:require))


