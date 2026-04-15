require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)
require "shipwright"
require "view_component"
require "tailwindcss-rails"

module Dummy
  class Application < Rails::Application
    config.load_defaults 8.1
    config.eager_load = false
  end
end
