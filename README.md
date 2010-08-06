Quotes Database
=======================

Install and run
-----------------------

1. Clone the Repository

  git clone git://github.com/uritu/quotes.git
  cd quotes

2. Install dependencies

  bundle install

3. Migrate the database 

  sequel -m db/migrate/ sqlite://db/quotes.db
  
4. Start the server

  ruby quotes.rb
  

Deploying to Heroku
-----------------------

Quotes Database is Heroku-ready, which means:

  git clone git://github.com/uritu/quotes.git
  cd quotes
  heroku create
  # ...
  git push heroku master
  
will create and launch Quotes DB as a fresh Heroku app