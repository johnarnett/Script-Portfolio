#!/bin/bash
# Update Adobe Reader at stores

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


sudo ssh root@$st_ip_r1 << EOF
cd /tmp
wget http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i486linux_enu.rpm
rpm -ivh AdbeRdr9.5.5-1_i486linux_enu.rpm
cp /opt/Adobe/Reader9/Browser/intellinux/nppdf.so /usr/lib/mozilla/plugins/
echo "y"
cd /home/zlink/.mozilla/firefox/1*
pkill firefox
cp prefs.js prefs.js.bak
sed -i 's|application/pdf||g' prefs.js
EOF

sudo ssh root@$st_ip_r2 << EOF
cd /tmp
wget http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i486linux_enu.rpm
rpm -ivh AdbeRdr9.5.5-1_i486linux_enu.rpm
cp /opt/Adobe/Reader9/Browser/intellinux/nppdf.so /usr/lib/mozilla/plugins/
echo "y"
cd /home/zlink/.mozilla/firefox/1*
pkill firefox
cp prefs.js prefs.js.bak
sed -i 's|application/pdf||g' prefs.js
EOF

echo "Updated Adobe at store " $st
