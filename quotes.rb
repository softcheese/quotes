require 'sinatra'
require 'haml'
require 'sequel'
require 'cgi'

configure { DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://db/quotes.db') } 

class Quote < Sequel::Model ; end
class OffensiveQuote < Sequel::Model(:quotes_o) ; end

before do
  request.path_info.gsub!(/\/o$/) do
    Quote = OffensiveQuote
    @o = true
    "/"
  end
end

get '/' do
  @quotes = Quote.reverse_order(:id)
  haml :index
end

get '/id/:id/?' do
  @quotes = Quote.filter(:id => params[:id]).all
  haml :index
end

get '/channel/:irc_chan/?' do
  @quotes = Quote.filter(:irc_chan => params[:irc_chan]).all
  haml :index
end

get '/by/:attrib/?' do
  @quotes = Quote.filter(:attrib => params[:attrib]).all
  haml :index
end

get '/submit' do
  @action = 'submit'
  haml :submit
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
  
  def o_value ; @o ? "/o" : "" ; end
end
  