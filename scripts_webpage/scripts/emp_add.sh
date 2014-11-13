#!/bin/bash
# Add Employee on Store System
# Syntax: <command> <store#> <salescode>

exec 1> tmp.out
exec 2> /dev/null

store=$1
emp=$2

ssh johna@<server> << PHP

function emp_update()
{
clear
#echo "Update Employee Info:"

. aprset > /dev/null
dbaccess <dbname> << ENDSQL

unload to /tmp/sls_update.unl
SELECT sls_id,
sls_last,
sls_first,
sls_phone,
sls_upd_flag,
sls_security,
sls_passwd,
sls_pay_id,
sls_pay_status,
sls_sick_hour,
sls_vac_hour,
sls_hr_rate,
sls_startdate,
sls_enddate,
sls_user1,
sls_user2,
sls_user3,
sls_user4,
sls_title
FROM slsman
WHERE sls_id = '$emp'

ENDSQL
}

emp_update $1

sudo scp /tmp/sls_update.unl root@z$1:/tmp

sudo ssh root@z$1 << EOF
cd /u/apropos
. ./getset > /dev/null
dbaccess <dbname> << ENDSQL
LOAD FROM /tmp/sls_update.unl insert into salesman;

UPDATE salesman
SET sl_passwd = sl_id
WHERE sl_id = '$emp';

SELECT * from salesman
where sl_id = '$emp';
ENDSQL
EOF
PHP
