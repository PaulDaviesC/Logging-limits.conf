#!/bin/bash
#This program sends mail using mutt when some new violations happen. Put this script to the crontab of the root user. We collect the report to "message" file and  this file is sent as the body of the mail. Mutt must be configure for the root user.

#Set the directory where you want to 
DIR=`dirname $0`

#This function is used to do some opearion during the exit
function finish
{
	/bin/cp $DIR/currop $DIR/prevop
	/bin/cp $DIR/currfsizelog $DIR/prevfsizelog
	/bin/cp $DIR/currnoproclog $DIR/prevnoproclog
	/bin/cp $DIR/currnofilelog $DIR/prevnofilelog
}

function send_mail
{
	cat $DIR/message | mail -s "[VIOLATION] Limits hit Detected" devs@codelearn.org pauldaviesc@gmail.com -aFrom:mail@ofpiyush.in
}
/bin/echo > $DIR/message
/sbin/aureport -x --failed --summary  -i -if /var/log/audit/audit.log > $DIR/currop

#Take the diffs of the current and previous output to see whether a new violation has happened from last check point.
/usr/bin/diff -N --suppress-common-lines $DIR/currop $DIR/prevop > $DIR/diffop 
if [[ $? -eq 0 ]] #If no new violation has happened from last checkpoint then exit.
then
	finish
	exit
fi

#If there is fsize violation add it to message.
/sbin/ausearch  -k fsize -sv no -if /var/log/audit/audit.log  > $DIR/currfsizelog
/usr/bin/diff -N --suppress-common-lines $DIR/currfsizelog $DIR/prevfsizelog > $DIR/diffop
if [[ $? -gt 0 ]] 
then
	echo "FILE SIZE VIOLATION" >> $DIR/message
	/usr/bin/awk '{if($2=="type=SYSCALL"){printf $16"\t";print $27}}' $DIR/diffop | /usr/bin/uniq -c >> $DIR/message
fi

#If there is a noproc violation add it to message.
/sbin/ausearch  -k noproc -sv no -if /var/log/audit/audit.log > $DIR/currnoproclog
/usr/bin/diff -N --suppress-common-lines $DIR/currnoproclog $DIR/prevnoproclog > $DIR/diffop
if [[ $? -gt 0 ]] 
then
	echo "PROCESS NUMBER VIOLATION" >> $DIR/message
	/usr/bin/awk '{if($2=="type=SYSCALL"){printf $16"\t";print $27}}' $DIR/diffop | /usr/bin/uniq -c >> $DIR/message
fi

#If there is a nofile violation add it to message.
/sbin/ausearch  -k nofile -sv no -if /var/log/audit/audit.log > $DIR/currnofilelog
/usr/bin/diff -N --suppress-common-lines $DIR/currnofilelog $DIR/prevnofilelog > $DIR/diffop
if [[ $? -gt 0 ]] 
then
	echo "NUMBER OF FILES VIOLATION" >> $DIR/message
	/usr/bin/awk '{if($2=="type=SYSCALL"){printf $16"\t";print $27}}' $DIR/diffop | /usr/bin/uniq -c  >> $DIR/message
fi

#Now the report is in message file.We will be sending the mail with message as body.
send_mail
finish
