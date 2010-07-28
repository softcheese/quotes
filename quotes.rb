require 'sinatra'
require 'haml'
require 'sequel'
require 'cgi'

get '/' do
  DB = open_database_connection
  @o = request.env['QUERY_STRING'] == 'o'
  @quotes = (@o ? DB[:quotes_o] : DB[:quotes]).order(:id.desc)
  haml :index
end

get '/id/:id' do
  DB = open_database_connection
  @o = request.env['QUERY_STRING'] == 'o'
  @quotes = (@o ? DB[:quotes_o] : DB[:quotes]).filter(:id => params[:id])
  haml :index
end

get '/channel/:channel' do
  DB = open_database_connection
  @o = request.env['QUERY_STRING'] == 'o'
  @quotes = (@o ? DB[:quotes_o] : DB[:quotes]).filter(:irc_chan => params[:channel])
  haml :index
end

get '/by/:attrib' do
  DB = open_database_connection
  @o = request.env['QUERY_STRING'] == 'o'
  @quotes = (@o ? DB[:quotes_o] : DB[:quotes]).filter(:attrib => params[:attrib])
  haml :index
end

get '/submit' do
  @action = 'submit'
  haml :submit
end

get '/reqinfo' do
    request.inspect
end

helpers do
  def partial(name, options = {})
    item_name = name.to_sym
    counter_name = "#{name}_counter".to_sym
    if collection = options.delete(:collection)
      collection.enum_for(:each_with_index).collect do |item, index|
        partial(name, options.merge(:locals => { item_name => item, counter_name => index + 1 }))
      end.join
    elsif object = options.delete(:object)
      partial name, options.merge(:locals => {item_name => object, counter_name => nil})
    else
      haml "_#{name}".to_sym, options.merge(:layout => false)
    end
  end

  def nl2br(text)
    text.gsub(/[\r\n]+/, '<br />')
  end

  def html_escape(text)
    Haml::Helpers.html_escape(text)
  end
end

def open_database_connection
  Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://db/quotes.db' )
end