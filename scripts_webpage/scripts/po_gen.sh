#!/bin/bash
# Autogenerates PO numbers for orders

exec 2>/dev/null

STORE=$1
COUNTRY=$2
COST=$3
DESC=$4
TODAY=$(date +"%m%d%Y")

if [ $(echo ${#DESC}) -gt "8" ]
        then
        DESC=${DESC//[aeiou]/};
        DESC="${DESC:0:8}";
fi

DESC=$(echo "$DESC" | tr a-z A-Z | tr -d " ");

case $COUNTRY in
US)
COUNTRY=01
;;
CA)
COUNTRY=02
;;
*) echo "Country requires valid entry (1 or 2). Exiting..." ; exit 0
;;
esac

case $COST in
[Yy]) COST="6810"
;;
[Nn]) COST="1690"
;;
*) echo "Cost requires valid entry (Y or N). Exiting..."; exit 0
;;
esac

#echo >> tmp.out
echo $STORE-$TODAY-$DESC >> tmp.out
echo $COUNTRY-$COST-0$STORE-$COUNTRY >> tmp.out
