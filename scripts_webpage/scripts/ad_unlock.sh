#!/bin/bash
# Powershell - Unlock AD Account

exec 1> tmp.out
exec 2> error.log

./powershell.sh << EOF
powershell Unlock-ADAccount $1
powershell confirm $1
# "confirm" is a pre-definied Powershell alias
EOF
