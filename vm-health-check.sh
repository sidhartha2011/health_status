#!/bin/bash

################################################################################
# Virtual Machine Health Check Script
# Description: Analyzes Ubuntu VM health based on CPU, Memory, and Disk Space
# Thresholds: Healthy if all parameters < 60%, Unhealthy if any > 60%
# Features: Support for --explain flag to show detailed health reasons
################################################################################

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Threshold for health status (in percentage)
THRESHOLD=60

# Variables to store status
HEALTH_STATUS="HEALTHY"
ISSUES=()
EXPLAIN_FLAG=false

################################################################################
# Function: Get CPU Usage (Ubuntu)
################################################################################
get_cpu_usage() {
  # Get CPU usage percentage (average across all cores)
  local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
  echo "${cpu_usage%.*}"
}

################################################################################
# Function: Get Memory Usage (Ubuntu)
################################################################################
get_memory_usage() {
  # Get memory usage percentage using free command (standard on Ubuntu)
  local total_mem=$(free | grep Mem | awk '{print $2}')
  local used_mem=$(free | grep Mem | awk '{print $3}')
  local memory_usage=$((used_mem * 100 / total_mem))
  echo "$memory_usage"
}

################################################################################
# Function: Get Disk Usage (Ubuntu)
################################################################################
get_disk_usage() {
  # Get disk usage percentage for root partition
  local disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
  echo "$disk_usage"
}

################################################################################
# Function: Get CPU Details for Explanation
################################################################################
get_cpu_details() {
  local cpu_usage=$1
  local num_cores=$(nproc)
  local load_avg=$(cat /proc/loadavg | awk '{print $1, $2, $3}')
  
  echo -e "${CYAN}CPU Details:${NC}"
  echo -e "  • Current Usage: ${BLUE}${cpu_usage}%${NC}"
  echo -e "  • Number of Cores: ${BLUE}${num_cores}${NC}"
  echo -e "  • Load Average (1m, 5m, 15m): ${BLUE}${load_avg}${NC}"
  
  if (( cpu_usage > THRESHOLD )); then
    echo -e "  • ${RED}⚠️  WARNING: CPU usage exceeds ${THRESHOLD}% threshold${NC}"
    echo -e "  • ${YELLOW}Recommendations:${NC}"
    echo -e "    - Check running processes with: ${BLUE}top${NC} or ${BLUE}ps aux${NC}"
    echo -e "    - Identify resource-heavy applications"
    echo -e "    - Consider scaling resources or optimizing processes"
  else
    echo -e "  • ${GREEN}✓ CPU usage is within acceptable limits${NC}"
  fi
  echo ""
}

################################################################################
# Function: Get Memory Details for Explanation
################################################################################
get_memory_details() {
  local memory_usage=$1
  local mem_info=$(free -h | grep Mem)
  local total=$(echo $mem_info | awk '{print $2}')
  local used=$(echo $mem_info | awk '{print $3}')
  local available=$(echo $mem_info | awk '{print $7}')
  
  echo -e "${CYAN}Memory Details:${NC}"
  echo -e "  • Current Usage: ${BLUE}${memory_usage}%${NC}"
  echo -e "  • Total Memory: ${BLUE}${total}${NC}"
  echo -e "  • Used Memory: ${BLUE}${used}${NC}"
  echo -e "  • Available Memory: ${BLUE}${available}${NC}"
  
  if (( memory_usage > THRESHOLD )); then
    echo -e "  • ${RED}⚠️  WARNING: Memory usage exceeds ${THRESHOLD}% threshold${NC}"
    echo -e "  • ${YELLOW}Recommendations:${NC}"
    echo -e "    - Check memory consumption with: ${BLUE}free -h${NC}"
    echo -e "    - Monitor processes: ${BLUE}ps aux --sort=-%mem | head${NC}"
    echo -e "    - Consider adding more RAM or stopping unnecessary services"
    echo -e "    - Check for memory leaks in running applications"
  else
    echo -e "  • ${GREEN}✓ Memory usage is within acceptable limits${NC}"
  fi
  echo ""
}

################################################################################
# Function: Get Disk Details for Explanation
################################################################################
get_disk_details() {
  local disk_usage=$1
  local disk_info=$(df -h / | tail -1)
  local total=$(echo $disk_info | awk '{print $2}')
  local used=$(echo $disk_info | awk '{print $3}')
  local available=$(echo $disk_info | awk '{print $4}')
  
  echo -e "${CYAN}Disk Space Details:${NC}"
  echo -e "  • Current Usage: ${BLUE}${disk_usage}%${NC}"
  echo -e "  • Total Disk Space: ${BLUE}${total}${NC}"
  echo -e "  • Used Disk Space: ${BLUE}${used}${NC}"
  echo -e "  • Available Disk Space: ${BLUE}${available}${NC}"
  
  if (( disk_usage > THRESHOLD )); then
    echo -e "  • ${RED}⚠️  WARNING: Disk usage exceeds ${THRESHOLD}% threshold${NC}"
    echo -e "  • ${YELLOW}Recommendations:${NC}"
    echo -e "    - Find large files: ${BLUE}du -sh /* | sort -hr${NC}"
    echo -e "    - Clean package cache: ${BLUE}sudo apt clean${NC}"
    echo -e "    - Remove old logs: ${BLUE}sudo journalctl --vacuum=30d${NC}"
    echo -e "    - Check for large log files in ${BLUE}/var/log${NC}"
    echo -e "    - Consider adding more disk space or archiving old data"
  else
    echo -e "  • ${GREEN}✓ Disk usage is within acceptable limits${NC}"
  fi
  echo ""
}

################################################################################
# Function: Analyze Health
################################################################################
analyze_health() {
  echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║   Ubuntu Virtual Machine Health Check Report          ║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}\n"

  # Get current metrics
  echo -e "${YELLOW}Gathering system metrics...${NC}\n"
  
  local cpu_usage=$(get_cpu_usage)
  local memory_usage=$(get_memory_usage)
  local disk_usage=$(get_disk_usage)

  # Display metrics summary
  echo -e "${BLUE}System Resource Usage Summary:${NC}"
  echo -e "  CPU Usage:     ${BLUE}${cpu_usage}%${NC}"
  echo -e "  Memory Usage:  ${BLUE}${memory_usage}%${NC}"
  echo -e "  Disk Usage:    ${BLUE}${disk_usage}%${NC}"
  echo -e "  Threshold:     ${YELLOW}${THRESHOLD}%${NC}\n"

  # Check CPU usage
  if (( cpu_usage > THRESHOLD )); then
    HEALTH_STATUS="UNHEALTHY"
    ISSUES+=("CPU usage is ${RED}${cpu_usage}%${NC} (exceeds ${THRESHOLD}% threshold)")
  else
    echo -e "  ✓ CPU usage ${GREEN}OK${NC} (${cpu_usage}% < ${THRESHOLD}%)"
  fi

  # Check Memory usage
  if (( memory_usage > THRESHOLD )); then
    HEALTH_STATUS="UNHEALTHY"
    ISSUES+=("Memory usage is ${RED}${memory_usage}%${NC} (exceeds ${THRESHOLD}% threshold)")
  else
    echo -e "  ✓ Memory usage ${GREEN}OK${NC} (${memory_usage}% < ${THRESHOLD}%)"
  fi

  # Check Disk usage
  if (( disk_usage > THRESHOLD )); then
    HEALTH_STATUS="UNHEALTHY"
    ISSUES+=("Disk usage is ${RED}${disk_usage}%${NC} (exceeds ${THRESHOLD}% threshold)")
  else
    echo -e "  ✓ Disk usage ${GREEN}OK${NC} (${disk_usage}% < ${THRESHOLD}%)"
  fi

  echo ""

  # Store metrics for explanation display
  export CPU_USAGE=$cpu_usage
  export MEMORY_USAGE=$memory_usage
  export DISK_USAGE=$disk_usage
}

################################################################################
# Function: Display Health Status
################################################################################
display_health_status() {
  echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
  
  if [ "$HEALTH_STATUS" = "HEALTHY" ]; then
    echo -e "${BLUE}║${NC} ${GREEN}✓ OVERALL HEALTH STATUS: HEALTHY${NC}                ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}\n"
    echo -e "${GREEN}All system resources are within acceptable limits.${NC}\n"
    return 0
  else
    echo -e "${BLUE}║${NC} ${RED}✗ OVERALL HEALTH STATUS: UNHEALTHY${NC}              ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}\n"
    echo -e "${RED}⚠️  Issues Detected:${NC}"
    for issue in "${ISSUES[@]}"; do
      echo -e "  • $issue"
    done
    echo ""
    return 1
  fi
}

################################################################################
# Function: Display Detailed Explanation
################################################################################
display_explanation() {
  echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║          Detailed Health Analysis & Explanation        ║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}\n"

  # Display CPU details
  get_cpu_details $CPU_USAGE

  # Display Memory details
  get_memory_details $MEMORY_USAGE

  # Display Disk details
  get_disk_details $DISK_USAGE

  # Overall explanation
  echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║              Overall Health Assessment                 ║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}\n"

  if [ "$HEALTH_STATUS" = "HEALTHY" ]; then
    echo -e "${GREEN}✓ HEALTHY SYSTEM${NC}"
    echo -e "All monitored resources (CPU, Memory, Disk) are below the ${THRESHOLD}% threshold."
    echo -e "The virtual machine is operating within normal parameters and no immediate action is required.\n"
  else
    echo -e "${RED}✗ UNHEALTHY SYSTEM${NC}"
    echo -e "One or more system resources are exceeding the ${THRESHOLD}% threshold."
    echo -e "Immediate action may be required to prevent performance degradation or system failures.\n"
    echo -e "${YELLOW}Suggested Actions:${NC}"
    echo -e "  1. Investigate the specific resource(s) that exceeded the threshold"
    echo -e "  2. Review running processes and services"
    echo -e "  3. Clean up unnecessary files or data"
    echo -e "  4. Consider scaling resources if needed"
    echo -e "  5. Monitor the system closely for further degradation\n"
  fi

  # System information
  echo -e "${CYAN}System Information:${NC}"
  echo -e "  • Hostname: ${BLUE}$(hostname)${NC}"
  echo -e "  • OS: ${BLUE}$(lsb_release -ds 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)${NC}"
  echo -e "  • Kernel: ${BLUE}$(uname -r)${NC}"
  echo -e "  • Uptime: ${BLUE}$(uptime -p)${NC}"
  echo -e "  • Current Time: ${BLUE}$(date '+%Y-%m-%d %H:%M:%S')${NC}\n"
}

################################################################################
# Function: Display Help
################################################################################
show_help() {
  cat << EOF
Usage: $0 [OPTIONS]

DESCRIPTION:
  Analyzes Ubuntu virtual machine health based on CPU, Memory, and Disk usage.
  Declares the VM as HEALTHY if all resources are below 60% utilized,
  and UNHEALTHY if any resource exceeds 60%.

OPTIONS:
  -h, --help              Show this help message
  -t, --threshold NUM     Set custom threshold percentage (default: 60)
  -e, --explain           Show detailed explanation for health status
  -c, --cpu-only          Check CPU usage only
  -m, --memory-only       Check Memory usage only
  -d, --disk-only         Check Disk usage only
  -v, --verbose           Show detailed information (same as --explain)

EXAMPLES:
  $0                      # Run full health check with default threshold
  $0 --explain            # Run with detailed explanation
  $0 -t 70                # Run with 70% threshold
  $0 -c                   # Check CPU usage only
  $0 -c -m                # Check CPU and Memory only
  $0 --explain -t 75      # Run with 75% threshold and detailed explanation

EXIT CODES:
  0                       VM is HEALTHY (all resources < threshold)
  1                       VM is UNHEALTHY (any resource >= threshold)

NOTES:
  • This script is optimized for Ubuntu/Debian-based systems
  • Requires 'top' and 'free' commands (included by default in Ubuntu)
  • May require elevated privileges for detailed system information

EOF
}

################################################################################
# Main Script
################################################################################
main() {
  # Parse command line arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        show_help
        exit 0
        ;;
      -t|--threshold)
        THRESHOLD="$2"
        shift 2
        ;;
      -e|--explain)
        EXPLAIN_FLAG=true
        shift
        ;;
      -c|--cpu-only)
        echo "CPU Usage: $(get_cpu_usage)%"
        exit 0
        ;;
      -m|--memory-only)
        echo "Memory Usage: $(get_memory_usage)%"
        exit 0
        ;;
      -d|--disk-only)
        echo "Disk Usage: $(get_disk_usage)%"
        exit 0
        ;;
      -v|--verbose)
        EXPLAIN_FLAG=true
        shift
        ;;
      *)
        echo "Unknown option: $1"
        show_help
        exit 1
        ;;
    esac
  done

  # Run health analysis
  analyze_health
  display_health_status

  # Display detailed explanation if --explain flag is set
  if [ "$EXPLAIN_FLAG" = true ]; then
    echo ""
    display_explanation
  fi
  
  # Exit with appropriate code
  if [ "$HEALTH_STATUS" = "HEALTHY" ]; then
    exit 0
  else
    exit 1
  fi
}

# Run main function
main "$@"
