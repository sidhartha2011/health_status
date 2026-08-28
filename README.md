# Virtual Machine Health Check Script

A comprehensive bash script for analyzing Ubuntu virtual machine health based on CPU, Memory, and Disk Space utilization. The script provides both quick status reports and detailed explanations for system resource usage.

## Table of Contents

- [Features](#features)
- [System Requirements](#system-requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Command Line Options](#command-line-options)
- [Output Examples](#output-examples)
- [Health Status Logic](#health-status-logic)
- [Detailed Explanation Mode](#detailed-explanation-mode)
- [Exit Codes](#exit-codes)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Features

✅ **Comprehensive Health Analysis**
- Monitors CPU, Memory, and Disk Space usage
- Sets configurable threshold (default: 60%)
- Declares VM as HEALTHY or UNHEALTHY based on thresholds

✅ **Detailed Explanation Mode**
- Use `--explain` flag to get in-depth analysis
- Shows specific metrics and recommendations for each resource
- Displays system information (hostname, OS, kernel, uptime)

✅ **Ubuntu-Optimized**
- Built specifically for Ubuntu/Debian-based systems
- Uses standard Ubuntu commands: `top`, `free`, `df`, `lsb_release`
- No external dependencies required

✅ **Flexible Options**
- Custom threshold percentages
- Individual resource checks (CPU, Memory, or Disk only)
- Verbose output for detailed diagnostics
- Comprehensive help documentation

✅ **Color-Coded Output**
- Green for healthy status
- Red for warnings/unhealthy status
- Yellow for recommendations
- Blue for informational text
- Cyan for detailed sections

## System Requirements

- **OS:** Ubuntu/Debian-based Linux distribution
- **Bash:** Version 4.0 or higher
- **Commands:** `top`, `free`, `df`, `nproc`, `lsb_release` (included by default)
- **Permissions:** Standard user access (elevated privileges optional for advanced diagnostics)

## Installation

### Step 1: Download or Clone the Repository

```bash
git clone https://github.com/sidhartha2011/features-copilot-plans.git
cd features-copilot-plans
```

### Step 2: Make the Script Executable

```bash
chmod +x vm-health-check.sh
```

### Step 3: Run the Script

```bash
./vm-health-check.sh
```

### Optional: Add to System PATH

To run the script from anywhere:

```bash
sudo cp vm-health-check.sh /usr/local/bin/vm-health-check
sudo chmod +x /usr/local/bin/vm-health-check
```

Then you can run it simply with:
```bash
vm-health-check
```

## Usage

### Basic Health Check

```bash
./vm-health-check.sh
```

Output:
```
╔════════════════════════════════════════════════════════╗
║   Ubuntu Virtual Machine Health Check Report          ║
╚════════════════════════════════════════════════════════╝

Gathering system metrics...

System Resource Usage Summary:
  CPU Usage:     45%
  Memory Usage:  52%
  Disk Usage:    38%
  Threshold:     60%

  ✓ CPU usage OK (45% < 60%)
  ✓ Memory usage OK (52% < 60%)
  ✓ Disk usage OK (38% < 60%)

╔════════════════════════════════════════════════════════╗
║ ✓ OVERALL HEALTH STATUS: HEALTHY                      ║
╚════════════════════════════════════════════════════════╝

All system resources are within acceptable limits.
```

### Detailed Explanation Mode

```bash
./vm-health-check.sh --explain
```

This provides:
- Detailed CPU, Memory, and Disk information
- Specific recommendations for each resource
- System information (hostname, OS, kernel, uptime)
- Overall assessment with suggested actions

## Command Line Options

### Help

```bash
./vm-health-check.sh -h
./vm-health-check.sh --help
```

Displays comprehensive help and usage examples.

### Custom Threshold

```bash
./vm-health-check.sh -t 70
./vm-health-check.sh --threshold 75
```

Set a custom threshold percentage. Values between 0-100 are supported.

### Explain (Detailed Mode)

```bash
./vm-health-check.sh -e
./vm-health-check.sh --explain
```

Shows detailed explanation with:
- CPU usage, cores, and load average
- Memory breakdown with recommendations
- Disk space analysis with cleanup suggestions
- System information
- Overall assessment

### CPU Only

```bash
./vm-health-check.sh -c
./vm-health-check.sh --cpu-only
```

Output:
```
CPU Usage: 45%
```

### Memory Only

```bash
./vm-health-check.sh -m
./vm-health-check.sh --memory-only
```

Output:
```
Memory Usage: 52%
```

### Disk Only

```bash
./vm-health-check.sh -d
./vm-health-check.sh --disk-only
```

Output:
```
Disk Usage: 38%
```

### Verbose Mode

```bash
./vm-health-check.sh -v
./vm-health-check.sh --verbose
```

Same as `--explain`. Shows detailed explanation for all resources.

## Output Examples

### Example 1: Healthy System

```bash
$ ./vm-health-check.sh
```

```
╔════════════════════════════════════════════════════════╗
║   Ubuntu Virtual Machine Health Check Report          ║
╚════════════════════════════════════════════════════════╝

Gathering system metrics...

System Resource Usage Summary:
  CPU Usage:     35%
  Memory Usage:  48%
  Disk Usage:    42%
  Threshold:     60%

  ✓ CPU usage OK (35% < 60%)
  ✓ Memory usage OK (48% < 60%)
  ✓ Disk usage OK (42% < 60%)

╔════════════════════════════════════════════════════════╗
║ ✓ OVERALL HEALTH STATUS: HEALTHY                      ║
╚════════════════════════════════════════════════════════╝

All system resources are within acceptable limits.
```

### Example 2: Unhealthy System with Explanation

```bash
$ ./vm-health-check.sh --explain
```

```
╔════════════════════════════════════════════════════════╗
║   Ubuntu Virtual Machine Health Check Report          ║
╚════════════════════════════════════════════════════════╝

Gathering system metrics...

System Resource Usage Summary:
  CPU Usage:     75%
  Memory Usage:  68%
  Disk Usage:    58%
  Threshold:     60%

  ✗ CPU usage CRITICAL (75% > 60%)
  ✗ Memory usage CRITICAL (68% > 60%)
  ✓ Disk usage OK (58% < 60%)

╔════════════════════════════════════════════════════════╗
║ ✗ OVERALL HEALTH STATUS: UNHEALTHY                    ║
╚════════════════════════════════════════════════════════╝

⚠️  Issues Detected:
  • CPU usage is 75% (exceeds 60% threshold)
  • Memory usage is 68% (exceeds 60% threshold)

╔════════════════════════════════════════════════════════╗
║          Detailed Health Analysis & Explanation        ║
╚════════════════════════════════════════════════════════╝

CPU Details:
  • Current Usage: 75%
  • Number of Cores: 4
  • Load Average (1m, 5m, 15m): 2.45 2.31 2.10
  • ⚠️  WARNING: CPU usage exceeds 60% threshold
  • Recommendations:
    - Check running processes with: top or ps aux
    - Identify resource-heavy applications
    - Consider scaling resources or optimizing processes

Memory Details:
  • Current Usage: 68%
  • Total Memory: 8.0G
  • Used Memory: 5.4G
  • Available Memory: 2.6G
  • ⚠️  WARNING: Memory usage exceeds 60% threshold
  • Recommendations:
    - Check memory consumption with: free -h
    - Monitor processes: ps aux --sort=-%mem | head
    - Consider adding more RAM or stopping unnecessary services
    - Check for memory leaks in running applications

Disk Space Details:
  • Current Usage: 58%
  • Total Disk Space: 100G
  • Used Disk Space: 58G
  • Available Disk Space: 42G
  • ✓ Disk usage is within acceptable limits

System Information:
  • Hostname: ubuntu-vm-01
  • OS: Ubuntu 22.04.1 LTS
  • Kernel: 5.15.0-56-generic
  • Uptime: 45 days, 3 hours, 12 minutes
  • Current Time: 2026-08-28 03:11:17
```

## Health Status Logic

### HEALTHY Status
The VM is declared **HEALTHY** when:
- CPU usage < 60% AND
- Memory usage < 60% AND
- Disk usage < 60%

### UNHEALTHY Status
The VM is declared **UNHEALTHY** when:
- CPU usage ≥ 60% OR
- Memory usage ≥ 60% OR
- Disk usage ≥ 60%

### Default Threshold
- **60%** (configurable via `--threshold` option)

### Resource Metrics Explained

**CPU Usage:**
- Percentage of total CPU capacity currently in use
- Averaged across all CPU cores
- Measured using `top` command

**Memory Usage:**
- Percentage of total RAM currently in use
- Includes: Process memory, buffers, cache
- Measured using `free` command

**Disk Usage:**
- Percentage of root partition (/) currently in use
- Includes: Files, directories, system data
- Measured using `df` command

## Detailed Explanation Mode

When you use the `--explain` flag, the script provides:

### CPU Analysis
- Current CPU usage percentage
- Number of available CPU cores
- Load average (1-minute, 5-minute, 15-minute)
- Recommendations if usage exceeds threshold:
  - Check processes with `top` or `ps aux`
  - Identify resource-heavy applications
  - Suggestions for resource optimization

### Memory Analysis
- Current memory usage percentage
- Total RAM available
- Currently used memory
- Available memory
- Recommendations if usage exceeds threshold:
  - View memory consumption with `free -h`
  - Monitor top memory-using processes
  - Suggestions for RAM upgrades or service optimization
  - Memory leak detection tips

### Disk Analysis
- Current disk usage percentage
- Total disk space
- Currently used disk space
- Available disk space
- Recommendations if usage exceeds threshold:
  - Find large files with `du` command
  - Clean package cache with `apt clean`
  - Remove old logs with `journalctl`
  - Check `/var/log` for large log files
  - Suggestions for disk space expansion

### System Information
- **Hostname:** VM's network name
- **OS:** Operating system and version
- **Kernel:** Linux kernel version
- **Uptime:** How long the system has been running
- **Current Time:** Timestamp of the check

## Exit Codes

| Code | Meaning | Description |
|------|---------|-------------|
| 0 | Success | VM is HEALTHY (all resources < threshold) |
| 1 | Failure | VM is UNHEALTHY (any resource ≥ threshold) |

### Using Exit Codes in Scripts

```bash
./vm-health-check.sh
if [ $? -eq 0 ]; then
    echo "System is healthy"
else
    echo "System needs attention"
fi
```

### Using Exit Codes with Cron Jobs

```bash
# Alert if system is unhealthy
./vm-health-check.sh || mail -s "VM Health Alert" admin@example.com
```

## Troubleshooting

### Issue: "Permission denied" when running the script

**Solution:**
```bash
chmod +x vm-health-check.sh
```

### Issue: Command not found for `top` or `free`

**Solution:**
These commands come standard with Ubuntu. Install them if missing:
```bash
sudo apt-get update
sudo apt-get install procps coreutils
```

### Issue: Getting "Unknown option" error

**Solution:**
Make sure you're using the correct flag syntax:
```bash
./vm-health-check.sh --explain    # Correct
./vm-health-check.sh -e           # Also correct
./vm-health-check.sh explain      # Wrong (missing -)
```

### Issue: Script shows very high CPU usage temporarily

**Solution:**
The script uses `top -bn1` which takes a brief measurement. High temporary spikes are normal. Run the check multiple times to get a better average.

### Issue: Different usage percentages reported vs. system commands

**Solution:**
Different tools measure usage differently:
- `top` measures active CPU usage
- `free` shows used memory (including buffers/cache)
- `df` shows filesystem usage

This is expected behavior. Use individual resource checks if needed:
```bash
./vm-health-check.sh --cpu-only
./vm-health-check.sh --memory-only
./vm-health-check.sh --disk-only
```

## Scheduling Regular Checks

### Using Cron (Every Hour)

```bash
# Edit crontab
crontab -e

# Add this line to run every hour and log results
0 * * * * /usr/local/bin/vm-health-check >> /var/log/vm-health.log 2>&1
```

### Using Cron (Every 30 Minutes)

```bash
*/30 * * * * /usr/local/bin/vm-health-check >> /var/log/vm-health.log 2>&1
```

### Using Systemd Timer

Create `/etc/systemd/system/vm-health-check.service`:
```ini
[Unit]
Description=VM Health Check Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/vm-health-check
StandardOutput=journal
StandardError=journal
```

Create `/etc/systemd/system/vm-health-check.timer`:
```ini
[Unit]
Description=VM Health Check Timer
Requires=vm-health-check.service

[Timer]
OnBootSec=5min
OnUnitActiveSec=1h
AccuracySec=1min

[Install]
WantedBy=timers.target
```

Enable and start:
```bash
sudo systemctl enable vm-health-check.timer
sudo systemctl start vm-health-check.timer
```

## Real-World Usage Examples

### Example 1: Daily Health Report

```bash
#!/bin/bash
# Send daily health report via email

REPORT=$(/path/to/vm-health-check.sh --explain)
echo "$REPORT" | mail -s "Daily VM Health Report - $(hostname)" admin@example.com
```

### Example 2: Alert on Unhealthy Status

```bash
#!/bin/bash
# Alert immediately if system becomes unhealthy

/path/to/vm-health-check.sh
if [ $? -ne 0 ]; then
    /path/to/vm-health-check.sh --explain | mail -s "URGENT: VM Health Alert" admin@example.com
fi
```

### Example 3: Monitor with Custom Threshold

```bash
#!/bin/bash
# Monitor with aggressive 70% threshold

/path/to/vm-health-check.sh --threshold 70 --explain
```

### Example 4: Automated Cleanup on High Disk Usage

```bash
#!/bin/bash
# Run health check and clean up if disk usage is high

/path/to/vm-health-check.sh -t 80
if [ $? -ne 0 ]; then
    echo "Cleaning package cache..."
    sudo apt clean
    sudo journalctl --vacuum=30d
    echo "Cleanup complete. Re-running health check..."
    /path/to/vm-health-check.sh --explain
fi
```

## Performance Considerations

- **Lightweight:** The script uses minimal system resources
- **Fast Execution:** Typically completes in 1-2 seconds
- **No External Dependencies:** Uses only built-in Linux utilities
- **Safe:** Read-only operations, no system modifications

## Security Considerations

- **No root required:** Works with standard user permissions
- **No external network calls:** Operates offline
- **Safe to run frequently:** Can be executed hourly via cron
- **No sensitive data exposure:** Only reports system metrics

## Contributing

Contributions are welcome! Areas for enhancement:

- [ ] Add support for other Linux distributions
- [ ] Network bandwidth monitoring
- [ ] Process-level monitoring
- [ ] Database integration for historical tracking
- [ ] Web UI dashboard
- [ ] Alerting integrations (Slack, PagerDuty, etc.)

## License

This script is provided as-is for educational and operational use.

## Author

Created by: NELAPATI SIDHARTHA ROY

## Support

For issues, suggestions, or contributions, please visit:
https://github.com/sidhartha2011/features-copilot-plans

---

**Last Updated:** 2026-08-28
**Version:** 1.0.0
