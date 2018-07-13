#!/bin/bash

# Incremental RSync backups for Perforce


rootdir='/root'
logfile='/var/log/perforce_backup.log'
rlogfile='/var/log/perforce_backup_rsync.log'
DOW=`date +"%u"`
vDate=`date +"%Y-%m-%d"`
DAYS_TO_KEEP=7

# Switch to script dir
cd $rootdir

# Redirect output and errors to logfile
exec 1>> $logfile
exec 2>&1
# Set script to exit on error
set -e

# Define steps to complete on error
function clean_fail() {
    #date >> files_open_by_perforce.log
    #lsof | grep perforce >> files_open_by_perforce.log
    script="Script failed: $BASH_SOURCE"
    err="Error on line $BASH_LINENO running command: $BASH_COMMAND"
    msg="Check errors in log file: $logfile"
    sed -e 's|email_body|'"$script"'\t\n'"$msg"'\t\n'"$err"'|g' email_template.txt > email_input.txt
    openssl s_client -crlf -quiet -connect email-smtp.us-east-1.amazonaws.com:465 < email_input.txt >/dev/null 2>&1
    rm -f email_input.txt
    echo "[FAILED] - Script exited early"
    for i in {1..78}; do echo -n "#"; done; echo $'\r'
}

# Exit cleanly on error
trap clean_fail ERR

start_time=`date`
echo "Start time: $start_time"
echo "Running as user: "
whoami >> $logfile

# Remove old backups
for f in /mnt/backup/perforce*.*; do
    find /mnt/backup/perforce*.* -mtime +$DAYS_TO_KEEP -exec rm -f {} \;
    break
done

if (($DOW == 6)); then
    echo "[$vDate]:start full archive"
    mv /root/backup.snar /root/backup.snar.old
    tar --create --exclude-from=/root/exclude-file.txt --preserve-permissions --listed-incremental=/root/backup.snar --total --gzip --file=/mnt/backup/perforce-fullbackup_"$vDate".tar.gz --label="$vDate" --files-from=/root/include-file.txt --warning=no-file-changed || [[ $? -ne 0 ]]
    sshpass -p 'password' rsync -avz --log-file=$rlogfile /mnt/backup/perforce-fullbackup_"$vDate".tar.gz user@server:/data/backups/perforce

else
    echo "[$vDate]:start difference archive"
    tar --create --exclude-from=/root/exclude-file.txt --preserve-permissions --listed-incremental=/root/backup.snar --total --gzip --file=/mnt/backup/perforce-backup-diff_"$vDate".tar.gz --label="$vDate" --files-from=/root/include-file.txt --warning=no-file-changed || [[ $? -ne 0 ]]
    sshpass -p 'password' rsync -avz --log-file=$rlogfile /mnt/backup/perforce-backup-diff_"$vDate".tar.gz user@server:/data/backups/perforce

    if (($? == 0))
    then
        echo "[$vDate]:done" >> $logfile
    fi
fi

# Visual identifiers for log file
end_time=`date`
echo "[SUCCESS] - Script finished successfully: $end_time"
for i in {1..78}; do echo -n "#"; done; echo $'\r'
#EOF

