#!/bin/bash
# Backup webserver scripts to remote host.
# Runs weekly.

exec 1>>/tmp/errors.log
exec 2>>/tmp/errors.log

cp -r /var/www/html/* /tmp/srv_backup
tar czvf /tmp/scripts_$(date +%m%d%Y).tgz /tmp/srv_backup/
sudo scp /tmp/scripts_$(date +%m%d%Y).tgz johna@<server>:/home/johna/srv_backup/
mv /tmp/scripts_$(date +%m%d%Y).tgz /tmp/srv_archive
rm -rf /tmp/srv_backup/*
