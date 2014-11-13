#!/bin/bash
# Powershell - Search AD Accounts

exec 1> tmp.out
exec 2> error.log


./powershell.sh "powershell search $1"
# "search" is a pre-defined Powershell alias
