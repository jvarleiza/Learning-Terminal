# Application-wide ActionCable module, containing ActionCable::Conection.
module ApplicationCable
  # For every websocket the cable server is accepting, a Connection object will
  # be instantiated. This instance becomes the parent of all the channel
  # subscriptions that are created from there on. Incoming messages are then
  # routed to these channel subscriptions based on an identifier sent by the
  # cable consumer. The Connection itself does not deal with any specific
  # application logic beyond authentication and authorization.
  class Connection < ActionCable::Connection::Base
  end
end
