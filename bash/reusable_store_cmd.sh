#!/bin/bash
# Reusable one-line command to run at all stores
# Replace variable "cmd" to reuse
# Prints failed attempts to "failed_stores.log"

function generate_stlist() {

. aprset
dbaccess atb << ENDSQL
unload to stores.unl
select st_id from stores
where st_type = 'S'
and st_status = 'O'
order by 1
ENDSQL
sed -i 's/|//g' stores.unl
}


function run_cmd() {

cmd="grep print_scaling /home/zlink/.mozilla/firefox/1*/prefs.js"

rm failed_stores.log
for i in $(cat stores.unl);
do echo $i 
check=$(sudo ssh root@z$i "$cmd")
check=${check//$'\n'/}
#check=${check//$' '/}

if [ "$?" -eq 1 ]; then
echo $i >> failed_stores.log
fi

echo "$i,$check" >> output.log

done
}

generate_stlist
run_cmd
