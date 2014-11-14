#!/bin/bash
# Updates Vagrant VMs with current SQL dump from production DB

# Download database dump
scp deploy@3rdpartyhost:~/sql/dump.sql.gz ./dump.sql.gz

# Make sure VM is running
vagrant up

# SSH to web vm and import new database dump
vagrant ssh web << EOF
cd /vagrant
n98-magerun.phar db:import --compression="gzip" /vagrant/dump.sql.gz
n98-magerun.phar db:import /vagrant/db_update.sql
n98-magerun.phar cache:flush
EOF

echo "
********************
 VM Sync Completed 
********************"