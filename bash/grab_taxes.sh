#!/bin/bash
rm taxes.csv
#rm stores.unl
#st_list

echo "Store,Tax Rate 1, Tax Rate 2, Tax Rate 3," >> taxes.csv

for i in $(cat stores.unl); do

sudo ssh root@z$i << EOF

cd /u/apropos
. ./getset

dbaccess apropos << ENDSQL
unload to /tmp/tax.unl
select st_id, st_tax_rate1, st_tax_rate2, st_tax_rate3
from store;
ENDSQL

ls /tmp/tax.unl
if [ $? -eq 2 ]; then
	echo "Fail: $HOSTNAME - Query" > /tmp/tax.unl
fi
EOF

if [ $? -ne 0 ]; then
	echo "Fail: $i - Connect" >> taxes.csv
else
	sudo ssh root@z$i 'cat /tmp/tax.unl' >> taxes.csv
fi

sed -i 's/|/,/g' taxes.csv

done

