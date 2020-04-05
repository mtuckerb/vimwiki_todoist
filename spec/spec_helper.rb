ENV['APP_ENV'] = 'test'
require './application'
require 'webmock/rspec'
require 'vcr'
require 'database_cleaner/sequel'


RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner[:sequel].strategy = :transaction
    DatabaseCleaner[:sequel].clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner[:sequel].cleaning do
      example.run
    end
  end

end

VCR.configure do |config|
  config.cassette_library_dir = "./spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end
