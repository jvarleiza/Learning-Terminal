# Pings are used as a health check by other services.
class PingController < ApplicationController
  # Let other services know that we are OK :)
  def ping
    head :ok
  end
end
