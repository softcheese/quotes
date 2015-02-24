$:.unshift File.dirname(__FILE__)
require 'bundler'
Bundler.require

require 'quotes'

namespace :db do
  desc "Migrate the database"
  task :migrate do
    system("sequel -m db/migrate/ #{Quotes::App::DB_URI}")
  end
end
