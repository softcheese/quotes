require 'bundler'

Bundler.require

require './lib/quotes'

namespace :db do
  desc "Migrate the database"
  task :migrate do
    system("sequel -m db/migrate/ #{Quotes::DB_URI}")
  end
end
