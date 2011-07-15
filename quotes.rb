require 'uri'

module Quotes
  class App < Sinatra::Application
    configure do
      DB_URI = ENV['DATABASE_URL'] || 'sqlite://db/quotes.db'
      Sequel.connect DB_URI
    end

    class Quote < Sequel::Model; end
    class OffensiveQuote < Sequel::Model(:quotes_o) ; end

    before do
      response.headers["Cache-Control"] = "public, max-age=300"
      @quote_type = if request.path_info =~ /\/o(\/)?$/
        @offensive = true
        OffensiveQuote
      else
        Quote
      end
    end


    get %r{/submit(.*?)} do
      erb :submit
    end

    get '/?:o?/?' do
      @quotes = @quote_type.reverse_order(:id)
      erb :index
    end

    get '/id/:id/?:o?/?' do
      @quotes = @quote_type.filter(:id => params[:id]).all
      erb :index
    end

    get '/channel/:irc_chan/?:o?/?' do
      @quotes = @quote_type.filter(:irc_chan => '#' + params[:irc_chan]).all + @quote_type.filter(:irc_chan => params[:irc_chan]).all
      erb :index
    end

    get '/by/:attrib/?:o?/?' do
      @quotes = @quote_type.filter(:attrib.like("%#{params[:attrib]}%")).all
      erb :index
    end

    put '/create/?:o?/?' do
      response.headers["Cache-Control"] = "no-cache"
      redirect @offensive ? '/o' : '/' if params[:spam_question].to_i != 100
      @quote = @quote_type.create({
        :quote => params[:quote],
        :attrib => params[:attrib],
        :context => params[:context],
        :irc => params[:irc].to_i,
        :irc_chan => params[:irc_chan],
        :date => Time.now.to_i
        })
      @quote.save
      redirect @offensive ? '/o' : '/'
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
          erb "_#{name}".to_sym, options.merge(:layout => false)
        end
      end

      def speakers_list(speakers)
        speakers.split(/,\s?((and|&)\s)?|\s?(&|and)\s?/)
      end

      def nl2br(text)
        text.gsub(/[\r\n]+/, '<br />')
      end

      def html_escape(text)
        ERB::Util.html_escape(text)
      end

      def o_value
        @offensive ? "/o" : "/"
      end

      def spam_question
        "What is four times twenty-five?"
      end
    end
  end
end

