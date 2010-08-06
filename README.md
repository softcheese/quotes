Quotes Database
===========================================================
Anonymous, user-submitted quotes database for when people
say really funny stuff. 


Install and run
-----------------------------------------------------------

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
-----------------------------------------------------------
Quotes Database is Heroku-ready, which means that this:

    git clone git://github.com/uritu/quotes.git
    cd quotes
    heroku create
    # ...
    git push heroku master
  
will create and launch Quotes DB as a fresh Heroku app.


Regular vs. Offensive
-----------------------------------------------------------
There are two types of quotes, regular and offensive. These
are stored in separate database tables, `quotes` and
`quotes_o`, respectively.

The regular quotes are what you see by default. To add an 
offensive quote, simply click the offensive quote link on
the regular quote submission page, and it will take you to 
the offensive quote submission page.

By adding a trailing '/o' to the end of the URL, you can 
see the offensive quotes. This works for all URLs,
including '/submit/o', '/create/o', and '/id/:id/o'.