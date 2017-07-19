#!/bin/bash
echo -n "Enter Store Number: "
read st
# Convert store number to IP

# Checks if input is equal to 3.
# If not, exits script

if [ ${#st} -ne 3 ]; then
        echo "Enter a 3-digit store number"
        exit 0
fi

# Seperate input characters with spaces
num=$(echo $st | sed 's/\(.\)/\1 /g')
var1=0

# Convert input into array
for i in $num
do array1[$var1]=$i;
((var1++));
done

# Define Variables for Reg 1 and 2 IPs
st_ip_r1="10."${array1[0]}"."${array1[1]}${array1[2]}".6"
st_ip_r2="10."${array1[0]}"."${array1[1]}${array1[2]}".7"

sudo scp files/Kill\ Firefox.desktop root@$st_ip_r1:/home/zlink/Desktop
sudo scp files/kill-ff.sh root@$st_ip_r1:/home/zlink

sudo scp files/Kill\ Firefox.desktop root@$st_ip_r2:/home/zlink/Desktop
sudo scp files/kill-ff.sh root@$st_ip_r2:/home/zlink

echo "Kill Firefox Icon now exists at store# " $st
