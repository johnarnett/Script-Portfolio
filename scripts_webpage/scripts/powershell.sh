#!/bin/bash
# Powershell Template. Connects to windows machine
# to run powershell commands against Active Directory.
# Uses Cygwin ssh server on windows host.

/usr/local/bin/sshpass -p '<password>' ssh -t ja-admin@windows "$1"
