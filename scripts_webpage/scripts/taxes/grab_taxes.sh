#!/bin/bash
# Get tax rates from all stores

exec 2>>errors.log

rm taxes.csv
#rm stores.unl

#st_list
echo "time started: " $(date) >> timestamp.log
echo "Store,Tax Rate 1, Tax Rate 2, Tax Rate 3," > taxes.csv
for i in $(cat stores.unl); do

sudo ssh root@z$i << EOF
cd /u/apropos
. ./getset
dbaccess apropos << ENDSQL

unload to /tmp/tax.unl
select st_id, st_tax_rate1, st_tax_rate2, st_tax_rate3
from store;
ENDSQL
EOF

sudo ssh root@z$i 'cat /tmp/tax.unl' >> taxes.csv

done

sed -i 's/|/,/g' taxes.csv

echo "The store tax file is attached." | mailx -a "/tmp/test.csv" -r solutionsdesk@zumiez.com -s "Tax Script Finished" johna@zumiez.com

echo "time finished: " $(date) >> timestamp.log
