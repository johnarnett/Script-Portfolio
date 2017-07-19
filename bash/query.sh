#!/bin/bash
# Reusable query to run at stores
# Payroll query as example

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


function run_query() {

#change query as needed
query="select t_date, count(*) from timesarc
where t_date > today-20
and t_slsid = 'SS1198'
group by 1
order by 1"

rm failed_stores.log
for i in $(cat stores.unl);
do echo $i 
check=$(sudo ssh root@z$i "cd /u/apropos; . ./getset 1>/dev/null; echo \"$query\" | dbaccess apropos 2>/dev/null")
#check=${check//$'\n'/}
#check=${check//$' '/}

if [ "$?" -eq 1 ]; then
echo $i >> failed_stores.log
fi

upd_check=$(echo "$check" | grep -v "count")
echo $upd_check
echo "$i: $upd_check" >> output.log

done
}

#generate_stlist
run_query $query

