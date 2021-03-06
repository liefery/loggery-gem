# frozen_string_literal: true

require "rails/railtie"
require "rails/rack/logger"

module Loggery
  module LogstashSetup
    def self.setup(config)
      config.logstash.type = config.loggery.log_type
      config.logstash.path = config.loggery.log_file if config.loggery.log_type == :file

      LogStashLogger.configure do |logstash|
        logstash.customize_event do |event|
          Loggery::Metadata::LogstashEventUtil.event_metadata(event)
        end
      end
    end
  end

  module LogrageSetup
    def self.setup(config)
      config.lograge.enabled                 = true
      config.lograge.keep_original_rails_log = false
      config.lograge.logger                  = Rails.logger
      config.lograge.formatter               = Lograge::Formatters::Logstash.new

      config.lograge.custom_options = ->(_event) do
        { event_type: :request }
      end
    end
  end

  module LoggerySetup
    def self.setup(app)
      LogstashSetup.setup(app.config)
      LogrageSetup.setup(app.config)

      app.config.middleware.insert_before Rails::Rack::Logger, Loggery::Metadata::Middleware::Rack
    end
  end

  class Railtie < Rails::Railtie
    config.loggery = OpenStruct.new

    # Default options
    config.loggery.enabled = true
    config.loggery.log_type = :file
    config.loggery.log_file = "log/logstash-#{Rails.env}.log"

    initializer :loggery, before: :logstash_logger do |app|
      LoggerySetup.setup(app) if app.config.loggery.enabled
    end
  end
end
