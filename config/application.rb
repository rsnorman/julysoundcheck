require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Julysoundcheck
  class Application < Rails::Application
    # add custom validators path
    config.autoload_paths += %W["#{config.root}/app/value_objects"]
    config.autoload_paths += %W["#{config.root}/app/presenters"]
    config.autoload_paths += %W["#{config.root}/app/services"]
  end
end
