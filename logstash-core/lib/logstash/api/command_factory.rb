# encoding: utf-8
require "logstash/api/service"
require "logstash/api/commands/system/basicinfo_command"
require "logstash/api/commands/system/plugins_command"
require "logstash/api/commands/stats"


module LogStash
  module Api
    class CommandFactory
      attr_reader :factory, :service

      def initialize(service)
        @service = service
        @factory = {
          :system_basic_info => ::LogStash::Api::Commands::System::BasicInfo,
          :plugins_command => ::LogStash::Api::Commands::System::Plugins,
          :stats => ::LogStash::Api::Commands::Stats
        }
      end

      def build(*klass_path)
        # Get a nested path with args like (:parent, :child)
        klass = klass_path.reduce(factory) {|acc,v| acc[v]}

        if klass
          klass.new(service)
        else
          raise ArgumentError, "Class path '#{klass_path}' does not map to command!"
        end
      end
    end
  end
end
