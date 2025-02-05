# frozen_string_literal: true
require 'time'

require_relative 'metrics/metric'
require_relative 'metrics/cpu'
require_relative 'metrics/ram'
require_relative 'metrics/network/main'
require_relative 'metrics/network/upload'
require_relative 'metrics/network/download'

require_relative 'views/main'
require_relative 'views/head'
require_relative 'views/menu'

module SystemMonitor
  class Plugin
    # substract 100ms to avoid time drift that could lead to nil values
    DRIFT_TIME = 100
    attr_reader :refresh_rate

    class << self
      def run(refresh_rate)
        new(refresh_rate).call
      end
    end

    def initialize(refresh_rate)
      @refresh_rate = refresh_rate * 1000 - DRIFT_TIME

      @cpu      = SystemMonitor::Metrics::Cpu.call(@refresh_rate)
      @ram      = SystemMonitor::Metrics::Ram.call(@refresh_rate)
      @upload   = SystemMonitor::Metrics::Network::Upload.call(@refresh_rate)
      @download = SystemMonitor::Metrics::Network::Download.call(@refresh_rate)

      @head_view = SystemMonitor::Views::Head
      @menu_view = SystemMonitor::Views::Menu
    end

    def call
      puts display_menu
    end

    private

    def display_menu
      [
        @head_view.upload(@upload),
        @head_view.download(@download),
        @head_view.cpu(@cpu),
        @head_view.ram(@ram),
      ].compact.reject(&:empty?).join(' - ') << " | #{@head_view.options}"
    end
  end
end