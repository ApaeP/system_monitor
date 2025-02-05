module SystemMonitor
  module Metrics
    module Network
      class Main < SystemMonitor::Metrics::Metric
        private

        def samples
          powermetrics_output = `#{cmd}`

          samples = powermetrics_output.scan(regex)
          return nil if samples.empty?

          samples
        end

        def regex
          /out:\s+[\d.]+\s+packets\/s,\s+([\d.]+)\s+bytes\/s\s*[\r\n]+in:\s+[\d.]+\s+packets\/s,\s+([\d.]+)\s+bytes\/s/
        end

        def cmd
          "sudo powermetrics --samplers network -i 100 -n #{@refresh_rate / 100} 2>/dev/null"
        end
      end
    end
  end
end
