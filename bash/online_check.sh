#!/bin/bash
. aprset
for i in $(cat stores.unl)
do

st=$(echo "select st_shp_st from stores where st_id = $i" | dbaccess atb 2>/dev/null | grep -v st_shp_st)
echo -n $i " - " $st " - "

ping -c 1 z$i > /dev/null
if [ "$?" -eq 0 ] ; then
echo "Online"
else
echo ""
echo $i >> offline_stores.log
fi
done

if [ -f offline_stores.log ] ; then
echo ""
echo "Offline Stores:"
echo ""


	for i in $(cat offline_stores.log)
	do

	st=$(echo "select st_shp_st from stores where st_id = $i" | dbaccess atb 2>/dev/null | grep -v st_shp_st)
	echo -n $i " - " $st " - "

	ping -c 10 z$i > /dev/null

		if [ "$?" -eq 0 ] ; then
		echo "Online"
		else
		echo "Offline"
		fi
	done
fi
