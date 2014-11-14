#!/bin/bash
# View HTTP access to webserver

ip=$(awk '{ print $1 }' /var/log/httpd/access_log)
date=$(awk '{ print $4 }' /var/log/httpd/access_log)
util=$(awk '{ print $7 }' /var/log/httpd/access_log)

var1=0
var2=0
var3=0
var4=0

for i in $ip
do column1[$var1]=$i;
((var1++));
done

for i in $date
do column2[$var2]=$i;
((var2++));
done

for i in $util
do column3[$var3]=$i;
((var3++));
done

for i in $ip
do echo ${column1[var4]}" - "${column2[var4]}"] - "${column3[var4]};
((var4++)) ;
done
