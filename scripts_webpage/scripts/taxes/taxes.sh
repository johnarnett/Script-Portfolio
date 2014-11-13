#!/bin/bash
# Kicks off script to grab taxes from all stores.
# Emails user with attached CSV and errors.

rm /var/www/html/scripts/taxes/errors.log
exec 1>/dev/null
exec 2>/var/www/html/scripts/taxes/errors.log

touch running
# SSH to USP to kick off tax script
ssh johna@zmvxaproposusp << EOF
cd /home/johna/scripts/taxes
source grab_taxes.sh ### This script has been included in this directory ***
EOF

# Grab tax file from USP
ssh johna@zmvxaproposusp "cat /home/johna/scripts/taxes/taxes.csv" > taxes.csv

# List errors in email
cat errors.log | grep -v Pseudo | grep -v stty | grep -v Database | grep -v unloaded | grep -v TERM > email.txt
sed -i '/^$/d' email.txt
sed -i '1s/^/\n\n/' email.txt
sed -i '1s/^/Script returned the following errors:\n/' email.txt

# Email Attached CSV file to user
echo "The store tax file is attached." | mail -a "taxes.csv" -r solutionsdesk@zumiez.com -s "Tax Script Finished" $1

# Email errors to user
sendmail -r scriptresults@zumiez.com $1 < email.txt

rm -rf running
