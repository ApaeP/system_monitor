module SystemMonitor
  module Metrics
    module Network
      class Download < SystemMonitor::Metrics::Network::Main
        private

        def evaluate
          samples.sum { |_, downloaded_bytes| downloaded_bytes.to_f }
        end
      end
    end
  end
end
