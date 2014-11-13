#!/bin/bash
# Lookup Store Info in Corporate DB

exec 1>tmp.out
exec 2>error.log
ssh johna@<server> << PHP

clear
. aprset

dbaccess <dbname> << ENDSQL
SELECT st_id,
st_desc,
st_add1,
st_add2,
st_add3,
st_phone,
st_manager,
st_tax_rate,
st_tax_rate2,
st_tax_rate3,
st_tax_rate4,
st_region,
st_open_date,
st_status,
st_county,
st_country,
st_region_mgr,
st_district,
st_dist_mgr
FROM stores
where st_id = $1
ENDSQL

PHP
