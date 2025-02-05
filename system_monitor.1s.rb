#!/usr/bin/env ruby
# frozen_string_literal: true

# <xbar.title>System Monitor (Network, CPU, RAM)</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Paul P</xbar.author>
# <xbar.author>@ApaeP</xbar.author>
# <xbar.desc>Displays real-time network throughput, CPU and RAM usage on macOS.</xbar.desc>
# <xbar.dependencies>ruby, powermetrics (via sudo)</xbar.dependencies>
# <xbar.abouturl>https://github.com/ApaeP/system_monitor</xbar.abouturl>

require_relative 'system_monitor/config/mac_os'
exit if lid_is_closed?

require_relative 'system_monitor/plugin'

REFRESH_RATE = __FILE__[/(?<=\.)\d+(?=s)/].to_i

SystemMonitor::Plugin.run(REFRESH_RATE)
