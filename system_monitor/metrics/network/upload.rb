module SystemMonitor
  module Metrics
    module Network
      class Upload < SystemMonitor::Metrics::Network::Main
        private

        def evaluate
          samples.sum { |uploaded_bytes, _| uploaded_bytes.to_f }
        end
      end
    end
  end
end
