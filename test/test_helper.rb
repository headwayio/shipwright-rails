ENV["RAILS_ENV"] = "test"

require_relative "dummy/config/environment"
require "rails/test_help"
require "view_component/test_helpers"

class ActiveSupport::TestCase
  # Add ViewComponent test helpers
end

class ViewComponent::TestCase
  # ViewComponent test helpers are included automatically
end
