# XBar System Monitor

A lightweight xbar plugin that provides real-time system resource monitoring directly in your macOS menu bar.

## Features

- 🌐 Network monitoring
  - Real-time upload/download bandwidth
  - Human-readable data formats (KB/s, MB/s, GB/s)
- 💻 System resources
  - CPU usage percentage
  - RAM usage percentage
- ⚡️ Performance
  - Lightweight and efficient monitoring
  - Configurable refresh rates
  - Minimal system impact
- 🛠 Smart features
  - Automatic suspension when laptop lid is closed
  - Clean menu bar display

## Requirements

- macOS
- [xbar](https://xbarapp.com/)
- Ruby
- sudo access for powermetrics (network monitoring)

## Installation

1. Install xbar from [xbarapp.com](https://xbarapp.com/)
2. Clone this repository:
   ```bash
   git clone https://github.com/YourUsername/xbar-system-monitor.git
   ```
3. Run the installation script:
   ```bash
   ./copy_to_plugins.sh
   ```
   Or manually copy the files:
   - Copy `system-monitor.1s.rb` to your xbar plugins folder
   - Copy the `system_monitor` directory to your xbar plugins folder
4. Make the plugin executable:
   ```bash
   chmod +x "~/Library/Application Support/xbar/plugins/system-monitor.1s.rb"
   ```
5. Refresh xbar

## Configuration

### Refresh Rate

The plugin updates every second by default. Modify the refresh rate by renaming the main file:
- `system-monitor.1s.rb` - updates every second
- `system-monitor.5s.rb` - updates every 5 seconds
- `system-monitor.1m.rb` - updates every minute

### Network Monitoring Setup

To enable network monitoring without password prompts, add this line to your sudoers file using `sudo visudo`:

```bash
your_username ALL=(root) NOPASSWD: /usr/bin/powermetrics
```

## Architecture

The plugin is built with a modular architecture:
- Metrics modules for each monitored resource
- View components for display formatting
- Configuration management
- Error handling and graceful degradation

## Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Ruby style guidelines
- Update documentation as needed
- Ensure backward compatibility

## License

MIT License - See [LICENSE](LICENSE) file for details

## Acknowledgments

- xbar community for the plugin platform
- Contributors and bug reporters