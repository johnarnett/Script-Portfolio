#!/bin/bash
#Delete Ghost Line in Receiver

DATE=$(date +%M%d%Y)

function rec_backup() {

. aprset
dbaccess atb << ENDSQL
unload to /tmp/ghost_detail_${DATE}.unl
select * from rec_detail
where rd_id = $1;

unload to /tmp/ghost_header_${DATE}.unl
select * from rec_header
where rh_id = $1;
ENDSQL
}

function rec_ghost_lines() {

. aprset
dbaccess atb << ENDSQL

DELETE FROM rec_detail
WHERE rd_id = "$1"
AND (rd_size1 = 0 
	AND rd_size2 = 0 
	AND rd_size3 = 0 
	AND rd_size4 = 0 
	AND rd_size5 = 0 
	AND rd_size6 = 0 
	AND rd_size7 = 0 
	AND rd_size8 = 0 
	AND rd_size9 = 0 
	AND rd_size10 = 0 
	AND rd_size11 = 0 
	AND rd_size12 = 0 
	AND rd_size13 = 0 
	AND rd_size14 = 0 
	AND rd_size15 = 0 
	AND rd_size16 = 0 
	AND rd_size17 = 0 
	AND rd_size18 = 0 
	AND rd_size19 = 0 
	AND rd_size20 = 0 
	AND rd_size21 = 0 
	AND rd_size22 = 0 
	AND rd_size23 = 0 
	AND rd_size24 = 0);

ENDSQL
}


function rec_update_status() {

. aprset
dbaccess atb << ENDSQL

UPDATE rec_header
SET rh_status = 'PST'
where rh_id = "$1"

ENDSQL
}


function rec_check_status() {
. aprset

STATUS=$(echo "SELECT count(*) FROM rec_detail
WHERE rd_id = \"$1\"
AND rd_status = 'PST'" | dbaccess atb 2>/dev/null | grep -v count)

COUNT=$(echo "SELECT count(*) FROM rec_detail
WHERE rd_id = \"$1\"" | dbaccess atb 2>/dev/null | grep -v count)

echo $STATUS
echo $COUNT

if [[ $STATUS -eq $COUNT ]]; then
rec_update_status $1
else
echo "Not a Match!"
fi

}


echo "Delete Ghost Lines"
echo -n "Enter a Receiver number: "
read RECEIVER

rec_backup $RECEIVER
rec_ghost_lines $RECEIVER
rec_check_status $RECEIVER
