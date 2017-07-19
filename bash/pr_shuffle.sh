#!/bin/bash

cd /tmp/comm_in
#cd /tmp/payroll
. aprset
declare -a ARRAY=()
echo Duplicate Entries:
for i in $(ls PR*); do
	COUNT=$(wc -l $i | awk {'print $1'})
	TOTAL=$(wc -l $i | awk {'print $1'})
	DUPLICATES=0
	for x in $(seq 1 $COUNT); do
		for y in {1..3}; do
			#echo "$x : $y"
			VAR=$(cut -d\| -f${y} $i | sed -n ${x}p)
			ARRAY[${y}]=$(echo $VAR)
		done
		SQL=$(echo "select * from payroll where pay_date = \"${ARRAY[1]}\" and pay_slsid = \"${ARRAY[2]}\" and pay_store = \"${ARRAY[3]}\"" | dbaccess atb 2>/dev/null)
		
		if [ -n "$SQL" ]; then
			#echo "$i - Duplicate entry"
			#echo "$i - ${ARRAY[@]}"
			DUPLICATES=$((DUPLICATES+1))
		fi
	done
	echo "$i Total: $TOTAL"
	echo "$i Duplicates: $DUPLICATES"
	
	if [ $DUPLICATES -eq $TOTAL ]; then
	mv $i /tmp/payroll
	fi
done
