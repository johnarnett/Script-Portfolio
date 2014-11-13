#!/bin/bash
# Reset Employee Password

exec 1>tmp.out
exec 2>/dev/null
ssh johna@<server> << PHP
clear
sudo ssh root@z$1 << EOF
cd /u/apropos
. ./getset >/dev/null
dbaccess <dbname> << ENDSQL
update salesman set sl_passwd = sl_id
where sl_id = '$2';
select sl_passwd from salesman where sl_id = '$2'
ENDSQL
EOF
PHP
