#!/bin/bash

echo -n "Enter Date (MMDDYYYY): "
read DATE

. aprset
dbaccess atb <<ENDSQL

unload to /tmp/payroll$DATE.unl
select * from payroll
where pay_date = '$DATE';

update payroll
set pay_act_hour2 = pay_act_hour1
where pay_act_hour2 = 0
and pay_date = '$DATE';

update payroll
set pay_act_hour1 = 0
where pay_date = '$DATE'

ENDSQL

echo "Payroll hours have been updated"
echo ""
echo "Wiki Reference:"
echo "http://wiki.zumiez.com/index.php/Apropos#Update_payroll_hours_to_holiday_hours"
