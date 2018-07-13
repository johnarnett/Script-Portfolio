#!/bin/bash

# Incremental RSync backups for Confluence


SCRIPT_DIR="/root/backup_scr"
BACKUP_NAME="confluence-"
BACKUP_DB_NAME=$BACKUP_NAME"db-dump.sql"
BACKUP_FULL_NAME=$BACKUP_NAME"full_"
BACKUP_DIFF_NAME=$BACKUP_NAME"diff_"
LOG_FILE="/var/log/confluence_backup.log"
RLOG_FILE="/var/log/confluence_backup_rsync.log"
BACKUP_DST="/var/backups"
REMOTE_DIR="/data/backups/docs"
REMOTE_HOST="servername"
DB_HOST="localhost"
DOW=`date +"%u"`
vDate=`date +"%Y-%m-%d"`
DAYS_TO_KEEP=7

# Switch to script dir
cd $SCRIPT_DIR
# Redirect output and errors to logfile
exec 1>> $LOG_FILE
exec 2>&1
# Set script to exit on error
set -e

# Define steps to complete on error
function clean_fail() {
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
whoami >> $LOG_FILE

function create_archive {
    tar --create --exclude-from=$SCRIPT_DIR/exclude-file.txt --preserve-permissions --listed-incremental=$SCRIPT_DIR/backup.snar --total --gzip --file=$BACKUP_DST/"$1""$vDate".tar.gz --label="$vDate" --files-from=$SCRIPT_DIR/include-file.txt
    sshpass -p 'jARe!6us' rsync -avz --log-file=$RLOG_FILE $BACKUP_DST/"$1""$vDate".tar.gz user@$REMOTE_HOST:$REMOTE_DIR
}

function full_archive {
    echo "[$vDate]:Create full archive"
    if [ -f $SCRIPT_DIR/backup.snar ]; then
	    echo "[$vDate]:Move backup.snar"
	    mv $SCRIPT_DIR/backup.snar $SCRIPT_DIR/backup.snar.old
    fi
    create_archive $BACKUP_FULL_NAME
}

function diff_archive {
    echo "[$vDate]:start difference archive" >> $LOG_FILE
    create_archive $BACKUP_DIFF_NAME
}


# Remove old backups
for f in $BACKUP_DST/$BACKUP_NAME*.*; do
    find $BACKUP_DST/$BACKUP_NAME*.* -mtime +$DAYS_TO_KEEP -exec rm -f {} \;
    break
done

# if previous code block uncommented, full_archive may run twice
if (($DOW == 6)); then
    full_archive
else
    diff_archive
fi
#--------------------

# Database backup
mysqldump -h $DB_HOST -u app -p<password> -C --routines --triggers --databases confluence --max_allowed_packet=512M > $BACKUP_DST/$BACKUP_DB_NAME
zip -r $BACKUP_DST/$BACKUP_DB_NAME.gz $BACKUP_DST/$BACKUP_DB_NAME -la -lf /var/log/backup_confluence_archive.log -li
sshpass -p <password> rsync -avz --log-file=$RLOG_FILE $BACKUP_DST/$BACKUP_DB_NAME.gz user@$REMOTE_HOST:$REMOTE_DIR

# Visual identifiers for log file
end_time=`date`
echo "[SUCCESS] - Script finished successfully: $end_time"
for i in {1..78}; do echo -n "#"; done; echo $'\r'
#EOF
