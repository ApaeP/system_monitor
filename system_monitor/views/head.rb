module SystemMonitor
  module Views
    class Head < SystemMonitor::Views::Main
      class << self
        def options
          "size=10 trim=false"
        end

        def ram(usage)
          "🂋 #{usage}%"
        end

        def cpu(usage)
          "⊞ #{usage}%"
        end

        def upload(usage)
          "△ #{human_readable_rate(usage)}"
        end

        def download(usage)
          "▽ #{human_readable_rate(usage)}"
        end
      end
    end
  end
end
