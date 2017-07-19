#!/bin/bash
# Clear Cache

rm -f stores.unl

# Generate Store List
#
. aprset
dbaccess atb << ENDSQL
unload to stores.unl
select st_id from stores
where st_type = 'S'
and st_status = 'O'
order by 1
ENDSQL
sed -i 's/|//g' stores.unl


# Script Body

exec 1>output.log
exec 2>output.log

CACHE1="rm -rf /home/zlink/.mozilla/firefox/1*/Cache*"
CACHE2="rm -rf /home/zlink/.mozilla/firefox/1*/cookies*"
CACHE3="rm -rf /home/zlink/.cache/mozilla/*"

for i in $(cat stores.unl); do
echo $i
sudo ssh -f root@z$i "pkill firefox; ${CACHE1}; ${CACHE2}; ${CACHE3}; ssh r002 \"pkill firefox; ${CACHE1}; ${CACHE2}; ${CACHE3};\""
done
