#!/bin/bash

echo -n "Enter Date (MMDDYYYY): "
read DATE

. aprset
dbaccess atb <<ENDSQL

unload to /tmp/payroll$DATE.unl
select * from payroll
where pay_date = '$DATE'
and pay_store in
('567','590','653','680');

update payroll
set pay_act_hour2 = pay_act_hour1
where pay_act_hour2 = 0
and pay_date = '$DATE'
and pay_store in
('567','590','653','680');

update payroll
set pay_act_hour1 = 0
where pay_date = '$DATE'
and pay_store in
('567','590','653','680');

ENDSQL

echo "Payroll hours have been updated"
