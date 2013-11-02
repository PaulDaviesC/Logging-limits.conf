#!/bin/bash
#This program sends mail using mutt when some new violations happen. Put this script to the crontab of the root user. Also in the root users home folder create a "message" file. This file is sent as the body of the mail. Mutt must be configure for the root user.
#mailto1 defines whome to the mail has to be sent. You can define another mail and then add it to the mutt command.
mailto1="pauldaviesc@gmail.com" 
/sbin/aureport -x --failed --summary -i -if /var/log/audit/audit.log > currop

#Take the diffs of the current and previous output.
/usr/bin/diff -N --suppress-common-lines currop prevop > diffop 

if [[ $? -gt 0 ]] #If there is a difference
then
	/usr/bin/mutt -s "[VIOLATION] Limits hit Detected" -a diffop <message -- $mailto1 2>/dev/null
fi
/bin/cp currop prevop
