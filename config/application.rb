# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Runner
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Moscow' # +0400

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.assets.precompile += %w[bootstrap-responsive-custom.css]
    config.assets.paths << Rails.root.join('/app/assets/fonts')
    config.i18n.enforce_available_locales = true
    config.middleware.use Rack::Deflater
    config.delayed_runs = nil

    config.github_helper = OnlyofficeGithubHelper::GithubClient.new(user: Rails.application.credentials.github_user,
                                                                    password: Rails.application.credentials.github_user_password)

    config.run_manager = nil
    config.threads = nil
    config.server_destroyer = nil

    config.action_mailer.perform_deliveries = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: Rails.application.credentials.failure_notification_domain,
      port: 587,
      domain: Rails.application.credentials.failure_notification_domain,
      user_name: Rails.application.credentials.failure_notification_username,
      password: Rails.application.credentials.failure_notification_password,
      authentication: 'plain',
      enable_starttls_auto: true
    }
    config.middleware.use ExceptionNotification::Rack,
                          email: {
                            email_prefix: '[wrata] ',
                            sender_address: Rails.application.credentials.failure_notification_username,
                            exception_recipients: Rails.application.credentials.admin_emails
                          }
    config.default_spec_language = ['en-US']
    config.node_docker_image = 'onlyofficetestingrobot/nct-at-testing-node:latest'

    config.generators do |generators|
      generators.integration_tool :rspec
      generators.test_framework :rspec
    end
  end
end
