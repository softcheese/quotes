require 'uri'

module Quotes
  DB_URI = ENV['DATABASE_URL'] || 'sqlite://db/quotes.db'

  autoload :App, './lib/quotes/app.rb'

end

