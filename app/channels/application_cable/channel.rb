# Application-wide ActionCable module, containing ActionCable::Channel.
module ApplicationCable
  # The channel provides the basic structure of grouping behavior into logical
  # units when communicating over the websocket connection. You can think of a
  # channel like a form of controller, but one that's capable of pushing content
  # to the subscriber in addition to simply responding to the subscriber's
  # direct requests.
  class Channel < ActionCable::Channel::Base
  end
end
