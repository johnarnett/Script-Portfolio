#!/bin/bash
# Powershell - List Locked-Out Accounts

exec 1> tmp.out
exec 2> error.log

./powershell.sh "powershell locked"
# "locked" is a pre-defined Powershell alias
