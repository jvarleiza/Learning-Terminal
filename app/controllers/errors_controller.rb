# Rails logs all 404s as FATALs by default, which is troublesome with LogScan.
# This controller will catch all 404 requests and instead log them as warnings.
class ErrorsController < ApplicationController
  skip_before_action :check_permissions
  
  # All bad routes caught by routes.rb will map to this method. We will log a
  # fatal only if we redirected a user to a non-existant page.
  def routing
    referer = request.env['HTTP_REFERER']
    if referer.present? && referer.include?(request.host)
      Rails.logger.fatal "#{referer} directs to non-existent route: " \
                         "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
    else
      Rails.logger.warn 'There was an attempt to access non-existent route: ' \
                        "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
    end
    render file: Rails.root.join('public', '404.html'), status: :not_found
  end
  
  def not_allowed
  end
end
