Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Always log to STDOUT in development instead of to a file.
  logger           = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = config.log_formatter
  config.logger    = ActiveSupport::TaggedLogging.new(logger)

  # Generate a random secret_key_base in development.  Cookies won't work
  # between restarts of the server!  Put this in Odin if you need stability even
  # in development
  config.secret_key_base = SecureRandom.hex(128)

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end


# Configuration for S3 integration
# require 'amazon/odin'
# require 'aws-sdk-for-ruby'
# require 'aws/odin_credentials'
# require 'aws-sdk-core'

# LEARNING_TERMINAL_BUCKET = 'eu-icqa-learning-terminal-docs'.freeze
# ICQA_CLI1_ODIN_MATERIAL = 'com.amazon.access.aws-euicqa-cli_user-1'.freeze

# begin
#   ODIN_FLX_USER = Amazon::Odin.retrieve_material(ICQA_CLI1_ODIN_MATERIAL, 'Principal').text.chomp
#   ODIN_FLX_PASS = Amazon::Odin.retrieve_material(ICQA_CLI1_ODIN_MATERIAL, 'Credential').text.chomp
#   Aws.config[:region] = 'eu-west-1'
#   Aws.config[:credentials] = Aws::OdinCredentials.new(ICQA_CLI1_ODIN_MATERIAL)
# rescue Exception => e
#   puts e.message
# end