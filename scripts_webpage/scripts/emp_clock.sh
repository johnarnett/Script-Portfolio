#!/bin/bash
# Show Clocked-in Employees

exec 1>tmp.out
exec 2>/dev/null

ssh johna@<server> << PHP
sudo ssh root@z$1 << EOF

cd /u/apropos
. ./getset > /dev/null

dbaccess <dbname> 2>/dev/null << ENDSQL
select t_slsid, t_name from times
where t_out = '00:00:00'
ENDSQL

EOF
PHP
