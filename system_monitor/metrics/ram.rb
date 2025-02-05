module SystemMonitor
  module Metrics
    class Ram < SystemMonitor::Metrics::Metric
      private

      def evaluate
        top_output = `top -l 1 | grep PhysMem:`
        if top_output =~ /PhysMem:\s+(\d+)([MG]) used.*,\s+(\d+)([MG]) unused/
          used   = $1.to_f
          unit1  = $2
          unused = $3.to_f
          unit2  = $4

          used_mb   = (unit1 == "G" ? used * 1024 : used)
          unused_mb = (unit2 == "G" ? unused * 1024 : unused)
          total_mb  = used_mb + unused_mb
          usage_percentage = (used_mb / total_mb) * 100
          return usage_percentage.round(2)
        end
        nil
      end
    end
  end
end
