require_relative 'boot'

require 'rails/all'
require 'rails'

# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

require 'amazon/rails_logger'
require 'amazon/odin'
require 'amazon/config'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Your application's module.
module LearningTerminalAppWebsite
  # Set domain agnostic configuration here.
  class Application < Rails::Application
    # Set up Amazon specific logging directories, file names, and rotators:
    # Log to the new rails-root directory, which is linked to var/output/logs
    # Change the log file name from {environment}.log to rails.log
    config.log_path = Pathname.new("#{ENV['ENVROOT']}/var/rails-root/log")
    config.paths['log'] = File.join(config.log_path, 'rails.log')
    config.rotate_logs = true
    config.logger_progname = Rails.application.class.parent_name

    # Replace this code with 'config.load_defaults 5.1' if using Rails 5.1
    if respond_to?(:action_controller)
      action_controller.per_form_csrf_tokens = true
      action_controller.forgery_protection_origin_check = true
    end
    ActiveSupport.to_time_preserves_timezone = true
    config.ssl_options = { hsts: { subdomains: true } }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # auto load libs
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    # config.eager_load_paths += Dir["#{config.root}/lib"]
    # config.autoload_paths << "#{Rails.root}/lib"
    
  end
end
