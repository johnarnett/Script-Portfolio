#!/bin/bash

# Update REG hours to HOL for states that require 
# holiday pay on Sundays (MA and RI).
# Called From:	Corporate Load Script

# Define Variables
TODAY=$(date +%m%d%Y)
DAY=$(date +%u)


# Set Environment / SQL query to update hours
. aprset
dbaccess <dbname> << ENDSQL

unload to /zumcust/scripts/payroll_sunday/archive/MA_RI_payroll$TODAY.unl 
select * from payroll
where pay_store in (select st_id from stores where st_shp_st in ('MA', 'RI'))
and pay_date = today-$DAY;

update payroll
set pay_act_hour2 = pay_act_hour1
where pay_act_hour2 = 0
and pay_store in (select st_id from stores where st_shp_st in ('MA', 'RI'))
and pay_date = today-$DAY;

update payroll
set pay_act_hour1 = 0
where pay_store in (select st_id from stores where st_shp_st in ('MA', 'RI'))
and pay_date = today-$DAY;

ENDSQL
