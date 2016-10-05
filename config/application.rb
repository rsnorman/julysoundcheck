require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Julysoundcheck
  class Application < Rails::Application
    # add custom validators path
    config.autoload_paths += %W("#{config.root}/app/value_objects")
    config.autoload_paths += %W("#{config.root}/app/presenters")
    config.autoload_paths += %W("#{config.root}/app/services")
    config.autoload_paths += %W("#{config.root}/app/form_objects")

    config.time_zone = 'Eastern Time (US & Canada)'

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each_pair do |key, value|
        ENV[key.to_s] = value
      end if File.exist?(env_file)
    end
  end
end
