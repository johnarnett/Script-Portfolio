#!/bin/bash
# ============================================================================
# Purpose:	Update REG hours to HOL for states that require 
#		holiday pay on Sundays (MA and RI).
#							
# Called From:	Corporate Load Script
# Author:	John Arnett
# Date:		05/23/2014
# Notes:	Requested by DanielleK
# ============================================================================

# Define Variables
TODAY=$(date +%m%d%Y)
DAY=$(date +%u)

# Set Environment / SQL query to update hours
. aprset
dbaccess atb << ENDSQL

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

# Remove archived payroll hours older than 60 days
find /zumcust/scripts/payroll_sunday/archive -not \( -type d -name ".?*" -prune \) -mtime +60 -exec rm -f {} \;

