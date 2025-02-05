module SystemMonitor
  module Views
    class Main
      class << self
        def human_readable_rate(bps)
          rate = if bps < 1024 * 1024
            "#{(bps / 1024.0).round(2)} KB/s"
          elsif bps < 1024 * 1024 * 1024
            "#{(bps / (1024.0 * 1024.0)).round(2)} MB/s"
          else
            "#{(bps / (1024.0 * 1024.0 * 1024.0)).round(2)} GB/s"
          end
          rate.rjust(10)
        end
      end
    end
  end
end
