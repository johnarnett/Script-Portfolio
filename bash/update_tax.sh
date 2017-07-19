#!/bin/bash
cd /home/johna/scripts/taxes/update

rm -f output.log
rm -f failed_connect.log
exec 1>>output.log
exec 2>>output.log

. aprset

for i in $(cat stores.unl); do

echo $i
TAX1=$(echo "select st_tax_rate from stores where st_id = \"$i\"" | dbaccess atb 2>/dev/null | grep -v st_tax_rate)
TAX2=$(echo "select st_tax_rate2 from stores where st_id = \"$i\"" | dbaccess atb 2>/dev/null | grep -v st_tax_rate)
TAX3=$(echo "select st_tax_rate3 from stores where st_id = \"$i\"" | dbaccess atb 2>/dev/null | grep -v st_tax_rate)
TAX4=$(echo "select st_tax_rate4 from stores where st_id = \"$i\"" | dbaccess atb 2>/dev/null | grep -v st_tax_rate)

echo $TAX1
echo $TAX2
echo $TAX3
echo $TAX4

sudo ssh root@z$i <<EOF
zap r001
zap r002

cd /u/apropos
. ./getset
dbaccess apropos <<ENDSQL

update store
set st_tax_rate1 = $TAX1;

update store
set st_tax_rate2 = $TAX2;

update store
set st_tax_rate3 = $TAX3;

update store
set st_tax_rate4 = $TAX4;


select st_tax_rate1, st_tax_rate2, st_tax_rate3, st_tax_rate4
from store;

ENDSQL

if [ $? -eq 255 ]; then
echo "SQL Error - Exiting..."
exit 127
fi

EOF

ERROR=$?

if [ "$ERROR" -eq 127 ]; then
echo $i >> failed_sql.log
fi

if [ "$ERROR" -eq 255 ]; then
echo $i >> failed_connect.log
fi

done

echo "Check the tax script!" | mail -s "Script Complete" johna@zumiez.com
