Sequel.migration do
  up do
    create_table(:quotes) do
      primary_key :id
      String :quote, :text => true
      String :attrib
      String :context
      Integer :date
      Integer :irc
      String :irc_chan
      String :irc_net
    end
  end
  
  down do
    drop_table(:quotes_o)
  end
end