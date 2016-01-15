$CASEFLOW_TEST_MODE = ENV.has_key?('CASEFLOW_TEST') && !ENV['CASEFLOW_TEST'].empty?

require File.expand_path('../boot', __FILE__)

require 'rails/all'
require './lib/sources/caseflow'
require './app/models/fakes'



# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Caseflow
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.assets.prefix = "/caseflow/assets"

    # Do not modify query parameters when empty arrays are passed
    config.action_dispatch.perform_deep_munge = false

    config.exceptions_app = self.routes
  end
end

# Make sure /tmp/forms directory is constructed after app boots up, or else forms cannot be generated!
FileUtils.mkdir_p(Rails.root + 'tmp' + 'forms') unless Dir.exist?(Rails.root + 'tmp' + 'forms')
