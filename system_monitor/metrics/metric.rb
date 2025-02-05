module SystemMonitor
  module Metrics
    class Metric
      class << self
        def call(refresh_rate)
          new(refresh_rate).call
        end
      end

      def initialize(refresh_rate)
        @refresh_rate = refresh_rate
      end

      def call
        evaluate
      end
    end
  end
end
