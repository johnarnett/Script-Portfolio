# Called from /zumcust/scripts/all_st_check/all_st_check.sh 
# Author: John Arnett
# Date: 12/9/2016

function run_query() {
cmd=$(. aprset 1>/dev/null; echo $1 | dbaccess atb 2>/dev/null)
result=$(echo "$cmd" | grep -v "count")
result=${result//$'\n'/}
result=${result//$' '/}
echo $result
}

# Set date
TODAY=$(date +%m%d%y)

# Query to grab PR record count
query_count="select count(distinct pay_store)
from payroll
where pay_date = today-1"

# Query to grab store count
query_total="select count(*) 
from stores
where st_status = 'O'
and st_type = 'S'"

total=$(run_query "${query_total}")
count=$(run_query "${query_count}")
check=$(($total - $count))

msg="Total Stores: $total
Loaded PR records: $count
Missing PR records: $check

MISSING PAYROLL RECORDS ARE ABOVE THE ACCEPTABLE THRESHOLD!
PLEASE INVESTIGATE!
"

#echo $msg

if [ $check -gt 100 ]; then
        echo "Success!"
        printf "$msg"
fi

#mail -s "US Payroll Check - FAILED - $TODAY - Missing PR Records" techsupport@zumiez.com otrs@zumiez.com sdeincident@zumiez.com < /zumcust/scripts/all_st_check/email.out
