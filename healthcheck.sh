
#!/bin/bash

# PRODUCTION SUPPORT - DAILY HEALTH CHECK SCRIPT
# Purpose: Perform basic server and application checks
#####################################################

echo "======================================"
echo "     PRODUCTION SERVER HEALTH CHECK"
echo "======================================"


# Save all output to a report file in the script's own directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT_FILE="$SCRIPT_DIR/health_check_$(date +%Y%m%d_%H%M%S)txt"
exec > >(tee "$REPORT_FILE") 2>&1

# 1. Check Disk Space Utilization
echo ""
echo "1. DISK SPACE UTILIZATION"
df -h

# 2. Check Memory Utilization
echo ""
echo "2. MEMORY UTILIZATION"
free -h

# 3. Check CPU Utilization
echo ""
echo "3. CPU UTILIZATION"
top -bn1 | head -5

# 4. Check Java Application Process
echo ""
echo "4. JAVA APPLICATION STATUS"
ps -ef | grep '[j]ava'

# 5. Check Nginx Service Status
echo ""
echo "5. NGINX SERVICE STATUS"
systemctl is-active nginx

# 6. Search ERROR Messages in Application Logs
echo ""
echo "6. APPLICATION ERROR MESSAGES"
if [ -f "application.log" ]; then
    grep -i "ERROR" application.log
else
    echo "Application log file not found"
fi

# 7. Display Last 10 Lines of Application Logs
echo ""
echo "7. LAST 10 APPLICATION LOG ENTRIES"
if [ -f "application.log" ]; then
    tail -10 application.log
else
    echo "Application log file not found"
fi

# 8. Monitor Application Logs Continuously
# Uncomment the below command when real-time monitoring is required.
# echo "8. REAL-TIME LOG MONITORING"
# tail -f application.log

# 9. Check Expected Input File
echo ""
echo "9. INPUT FILE VALIDATION"
if [ -f "/data/input/input.csv" ]; then
    echo "Input file exists"
else
    echo "WARNING: Input file is missing"
fi

# 10. Check Application URL Connectivity
echo ""
echo "10. APPLICATION URL CHECK"
curl -I --max-time 10 https://example.com

# 11. Find Files Older Than 7 Days
echo ""
echo "11. FILES OLDER THAN 7 DAYS"
find /data -type f -mtime +7 -print 2>/dev/null

# 12. Find Old Log Files for Cleanup
# First display files; do not delete without approval.
echo ""
echo "12. LOG FILES OLDER THAN 30 DAYS"
find /data/logs -type f -name "*.log" -mtime +30 -print 2>/dev/null

# 13. Check Server Uptime
echo ""
echo "13. SERVER UPTIME"
uptime

# 14. Display Running Processes
echo ""
echo "14. RUNNING PROCESSES"
ps -ef | head -20

# 15. Check Network Connectivity
echo ""
echo "15. NETWORK CONNECTIVITY"
ping -c 4 google.com

#####################################################
# END OF HEALTH CHECK
#####################################################

echo ""
echo "======================================"
echo "     HEALTH CHECK COMPLETED"
echo "======================================"

