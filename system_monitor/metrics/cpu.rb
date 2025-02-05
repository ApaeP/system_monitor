module SystemMonitor
  module  Metrics
    class Cpu < SystemMonitor::Metrics::Metric
      private

      def evaluate
        top_output = `top -l 1 | grep "CPU usage:"`
        return nil if top_output.empty?

        if top_output =~ /CPU usage:\s+([\d.]+)% user,\s+([\d.]+)% sys/
          user = $1.to_f
          sys  = $2.to_f
          total = user + sys
          return total.round(2)
        end
        nil
      end
    end
  end
end
