# XBar System Monitor

A xbar plugin to monitor system resources directly in your macOS menu bar.

## 🚧 Work in Progress 🚧

This plugin is currently under development and allows real-time monitoring of:
- 🌐 Network usage (upload/download bandwidth)
- 💻 CPU usage
- 🎮 GPU usage
- 🧮 RAM usage
- 💽 Available disk space

## Features

- Lightweight and efficient monitoring
- Real-time updates in the menu bar
- Detailed dropdown menu with additional information
- Automatic network interface detection
- Human-readable data formats (KB/s, MB/s, GB/s)
- Handles laptop lid closure state

## Installation

1. Install [xbar](https://xbarapp.com/) if you haven't already
2. Download this plugin to your xbar plugins folder
3. Make the script executable (`chmod +x system-monitor.1s.rb`)
4. Refresh xbar

## Configuration

The plugin refreshes every second by default. You can modify this interval by renaming the file:
- `system-monitor.5s.rb` for 5 seconds
- `system-monitor.1m.rb` for 1 minute

### Sudo Access for GPU Monitoring
To enable GPU monitoring without sudo prompt, add this to your sudoers file:
```
your_username ALL=(root) NOPASSWD: /usr/bin/powermetrics
```

## Requirements

- Ruby
- macOS
- xbar
- sudo access to powermetrics

## Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest improvements
- Submit pull requests

## License

MIT License - See LICENSE file for details