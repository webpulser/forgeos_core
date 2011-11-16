# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "authlogic/test_case"
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  self.fixture_path = (File.expand_path("../fixtures",  __FILE__))
  self.fixtures :all
  include Authlogic::TestCase

  def admin_login_to(controller, action)
    role = Forgeos::Role.create(
      :name => 'admin',
      :rights => [Forgeos::Right.create(
        :name => 'administrators_index',
        :controller_name => "forgeos/#{controller}",
        :action_name => action
      )]
    )
    admin = forgeos_people(:administrator)
    admin.role = role
    Forgeos::PersonSession.create(admin)
  end
end
