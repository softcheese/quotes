require 'quotes'

namespace :db do
  desc "Migrate the database"
  task :migrate do
    system("sequel -m db/migrate/ #{DB_URI}")
  end
end