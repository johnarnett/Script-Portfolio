#!/bin/bash
# Grabs "Last Modified" date from the last 3 Sales Planning Tools at all stores

# $1 Loop
for i in $(cat stores.unl); do
echo $i
OUTPUT=$(sudo ssh root@z$i "ls -l --time-style=+"%m/%d/%Y" /home/zlink/Documents/SalesPlanningTool_???2015$1.xls")

if [ "$?" -eq 255 ]; then
echo $i >> failed_stores_$1.log
fi

DATE=$(echo $OUTPUT | awk '{ print $6 }')
echo "$i - $DATE" >> output_$1.log
done


# $2 Loop
for i in $(cat stores.unl); do
echo $i
OUTPUT=$(sudo ssh root@z$i "ls -l --time-style=+"%m/%d/%Y" /home/zlink/Documents/SalesPlanningTool_???2015$2.xls")

if [ "$?" -eq 255 ]; then
echo $i >> failed_stores_$2.log
fi

DATE=$(echo $OUTPUT | awk '{ print $6 }')
echo "$i - $DATE" >> output_$2.log
done


# $3 Loop
for i in $(cat stores.unl); do
echo $i
OUTPUT=$(sudo ssh root@z$i "ls -l --time-style=+"%m/%d/%Y" /home/zlink/Documents/SalesPlanningTool_???2015$3.xls")

if [ "$?" -eq 255 ]; then
echo $i >> failed_stores_$3.log
fi

DATE=$(echo $OUTPUT | awk '{ print $6 }')
echo "$i - $DATE" >> output_$3.log
done

# Parse output for CSV format
for i in $(cat stores.unl); do
echo $i

FILE1=$(cat output_$1.log | grep "$i - " | awk '{ print $3 }')
FILE2=$(cat output_$2.log | grep "$i - " | awk '{ print $3 }')
FILE3=$(cat output_$3.log | grep "$i - " | awk '{ print $3 }')

echo "$i,$FILE1,$FILE2,$FILE3" >> sales_planning_dates.csv
done
