require 'simplecov'

# This file is copied to spec/ when you run 'rails generate rspec:install'
require File.expand_path('../../config/environment', __FILE__)

require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Infer what kind of test the file is by its folder structure.
  config.infer_spec_type_from_file_location!

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
  
  #the following two lines were added because otherwise spec_helper couldn't be found by the _spec.rb files.
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end