#!/bin/bash
# Check if sales exist for previous day

exec 1>>output.log
exec 2>>output.log


for i in $(cat stores.unl); do
echo $i
sudo ssh root@z$i <<EOF

cd /u/apropos
. ./getset
dbaccess <dbname> << ENDSQL

select count(*) from in_headerarc
where in_date = today-1;
select count(*) from in_header
where in_date = today-1;
ENDSQL


EOF

done

cat output.log | grep -v Pseudo | grep -v TERM | grep -v APROPOS | grep -v count | grep -v Database | grep -v retrieved> output2.log

sed -i '/^$/d' output2.log
