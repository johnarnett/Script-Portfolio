#!/bin/bash
#
# Powershell - AD Account Lookup

exec 1> tmp.out
exec 2> error.log

./powershell.sh "powershell info $1"
# "info" is a pre-defined Powershell alias
