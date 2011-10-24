# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "authlogic/test_case"
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ActiveSupport::TestCase.use_transactional_fixtures = true
ActiveSupport::TestCase.use_instantiated_fixtures  = false
ActiveSupport::TestCase.fixture_path = (File.expand_path("../fixtures",  __FILE__))
ActiveSupport::TestCase.fixtures :all

ActiveSupport::TestCase.send(:include, Authlogic::TestCase)
