#!/bin/bash
# Store lookup by phone number

exec 1>tmp.out
exec 2>/dev/null

#Seperate input characters with spaces
num=$(echo $1 | sed 's/\(.\)/\1 /g')
var1=0

#Convert input into array
for i in $num
do array1[$var1]=$i;
((var1++));
done

phone=${array1[0]}${array1[1]}${array1[2]}"-"${array1[3]}${array1[4]}${array1[5]}"-"${array1[6]}${array1[7]}${array1[8]}${array1[9]}

ssh johna@<server> << PHP
. aprset

dbaccess <dbname> << ENDSQL
SELECT st_id, 
st_desc, 
st_add1, 
st_add2, 
st_add3, 
st_phone 
FROM stores
WHERE st_phone = '$phone'
ENDSQL

PHP
