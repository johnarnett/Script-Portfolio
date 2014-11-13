#!/bin/bash
# Employee Info

exec 1>tmp.out
exec 2>/dev/null
ssh johna@<server> << PHP
. aprset
dbaccess <dbname>
select * from slsman
where sls_id = '$1'
PHP
