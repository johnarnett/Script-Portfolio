#!/bin/bash
# Store Printer Information

exec 1>tmp.out
exec 2>/dev/null
ssh johna@<server> << PHP
echo
sudo ssh root@z$1 << EOF
TERM=vt100 export TERM
lynx -source ipreport | awk '/Brother HL/' | awk '{gsub("<TITLE>", "");print}' | awk '{gsub("</TITLE>", "");print}'
lynx -dump ipreport/printer/main.html | grep Serial
lynx -dump ipreport/printer/maininfo.html | grep -A 10 "Remaining Life"
lynx -source ipreport | awk '/Lexmark E/' | awk '{gsub("<TITLE>", "");print}' | awk '{gsub("</TITLE>", "");print}'
lynx -dump http://ipreport/cgi-bin/dynamic/printer/PrinterStatus.html | grep -A 1 "Toner Status"
lynx -dump http://ipreport/cgi-bin/dynamic/printer/PrinterStatus.html | grep -A 4 "Device Type"
lynx -dump http://ipreport/cgi-bin/dynamic/printer/config/reports/deviceinfo.html | grep -A 2 "Serial Number" | awk 'NF > 0'
echo -n "Number of jobs processed today: "
cat /var/log/cups/page_log* | grep -c $(date "+%d")/$(date "+%b") 
EOF
PHP
