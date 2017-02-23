require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Festival
  class Application < Rails::Application
    require 'letter_opener' if Rails.env.development?
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # Set Time Zone
    config.time_zone = 'Eastern Time (US & Canada)'
  end
end
