#!/bin/bash

for i in $(cat stores.unl); do
sudo ssh root@z$i << EOF
pkill firefox
rm -rf /home/zlink/.mozilla/firefox/1*/Cache*
rm -rf /home/zlink/.mozilla/firefox/1*/cookies*
rm -rf /home/zlink/.cache/mozilla/*
ssh r002 "pkill firefox; rm -rf /home/zlink/.mozilla/firefox/1*/Cache*; rm -rf /home/zlink/.mozilla/firefox/1*/cookies*; rm -rf /home/zlink/.cache/mozilla/*"
EOF

if [ "$?" -eq 255 ]; then
echo $i >> failed_stores.log
fi

done
