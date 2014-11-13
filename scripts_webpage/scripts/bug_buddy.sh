#!/bin/bash
#
# Bug Buddy Fix
# Resolves mailbox issues with Evolution
# that are caught by the CentOS Bug Reporting Tool

exec 1>/dev/null
exec 2>/dev/null

ssh johna@<server> << PHP
sudo ssh root@z$1 << EOF

cd /home/zlink/.evolution/mail/local
pkill evolution
rm -f Drafts.* Inbox.* Outbox.* Sent.*
cp Inbox /tmp/inbox_backup.bak
cp Inbox /tmp/Inbox.bak
cat /dev/null > Inbox

export DISPLAY=:0.0;
sudo -u zlink /usr/bin/evolution --online &
sleep 5

pkill evolution
cat Inbox >> /tmp/Inbox.bak
cp -f /tmp/Inbox.bak Inbox

EOF
PHP

