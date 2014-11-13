#!/bin/bash
# Remove duplicate allocation records

. aprset

size=""
for i in {1..24}; do size=$size"size_$i, "; done
size=$(echo $size | sed 's/.$//')

echo -n "Enter Allocation ID: "
read alloc

var1=$(echo "select store_id, count(*)
from allocation_stores
where allocation_id=$alloc
group by 1 having count(*) > 1" | dbaccess <dbname> 2>/dev/null | grep -v store_id)


store_id=$(echo $var1 | awk '{ print $1 }')
count=$(echo $var1 | awk '{ print $2 }')

echo "Store Id : "$store_id
echo "Count    : "$count

if [ $count -ne 2 ]; then
echo "Too many duplicates. Troubleshoot manually.
Exiting..."
exit 0
fi

read -p "Press any key to continue..."


alloc_id=$(echo "select alloc_store_id from allocation_stores
where allocation_id=$alloc
and store_id=$store_id" | dbaccess <dbname> 2>/dev/null | grep -v alloc_store_id)

echo $alloc_id
alloc_id1=$(echo $alloc_id | awk '{ print $1 }')
alloc_id2=$(echo $alloc_id | awk '{ print $2 }')

for i in $alloc_id; do
dbaccess <dbname> << ENDSQL
unload to $i.unl
select $size from allocation_stores
where allocation_id=$alloc
and store_id=$store_id
and alloc_store_id=$i
ENDSQL
done

size_1=$(cat $alloc_id1.unl | md5sum)
size_2=$(cat $alloc_id2.unl | md5sum)

if [ "$size_1" = "$size_2" ]; then

echo "Duplicate Allocations - Deleting..."

dbaccess <dbname> << ENDSQL
unload to /tmp/allocation_stores.unl
select * from allocation_stores
where allocation_id=$alloc
and store_id=$store_id
and alloc_store_id=$alloc_id1;
ENDSQL

if [ $? -eq 255 ]; then
echo "Error unloading table - Exiting..."
exit 255
fi

dbaccess <dbname> << ENDSQL
delete from allocation_stores
where allocation_id=$alloc
and store_id=$store_id
and alloc_store_id=$alloc_id1;
ENDSQL

if [ $? -eq 255 ]; then
echo "Error deleting table - Exiting..."
exit 255
fi

echo "Duplicate record successfully deleted!"

else
echo "Records are different - No Action Taken"
fi

rm *.unl

