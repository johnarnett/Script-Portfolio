#!/bin/bash
# Kill Firefox

exec 1>tmp.out
exec 2>/dev/null
ssh johna@<server> << PHP

sudo ssh root@z$1 << EOF
pkill firefox
rm -rf /home/zlink/.mozilla/firefox/1*/Cache*
rm -rf /home/zlink/.mozilla/firefox/1*/cookies*
rm -rf /home/zlink/.cache/mozilla/*

ssh r002 << EOL
pkill firefox
rm -rf /home/zlink/.mozilla/firefox/1*/Cache*
rm -rf /home/zlink/.mozilla/firefox/1*/cookies*
rm -rf /home/zlink/.cache/mozilla/*

EOL
EOF
PHP

echo "Killed Firefox. Cleared Cache." > tmp.out
