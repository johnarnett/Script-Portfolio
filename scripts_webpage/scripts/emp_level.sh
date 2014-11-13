#!/bin/bash
# Change Security Level

exec 1>tmp.out
exec 2>/dev/null
ssh johna@<server> << PHP
sudo ssh root@z$1 << EOF
cd /u/apropos
. ./getset > /dev/null
dbaccess <dbname> << ENDSQL
update salesman set sl_level = '$2' 
where sl_id = '$3';
select sl_level from salesman where sl_id = '$3'
ENDSQL
EOF
PHP
