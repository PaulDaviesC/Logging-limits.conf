#!/bin/bash
#This program sends mail using mutt when some new violations happen. Put this script to the crontab of the root user. We collect the report to "message" file and  this file is sent as the body of the mail. Mutt must be configure for the root user.

#Set the directory where you want to 
function send_mail
{
	cat $DIR/message | mail -s "[VIOLATION] Limits hit Detected" devs@codelearn.org pauldaviesc@gmail.com -aFrom:mail@ofpiyush.in
}

#This function is used to do some opearion during the exit
function finish
{
	/bin/cp $DIR/currop $DIR/prevop
	/bin/cp $DIR/currfsizelog $DIR/prevfsizelog
	/bin/cp $DIR/currnoproclog $DIR/prevnoproclog
	/bin/cp $DIR/currnofilelog $DIR/prevnofilelog
	/bin/cp $DIR/currmemlocklog $DIR/prevmemlocklog
	/bin/cp $DIR/currcputimelog $DIR/prevcputimelog
	#$sendmail is passed in as an arg. send mail only if it is set to >0.
	if [[ $1 -gt 0 ]]
	then
		send_mail
	fi
}

function main
{
	DIR=`dirname $0`
	/bin/echo > $DIR/message
	sendmail=0

	/bin/grep sig=24 /var/log/audit/audit.log > $DIR/currcputimelog
	/usr/bin/diff -N --suppress-common-lines $DIR/currcputimelog $DIR/prevcputimelog > $DIR/diffop 
	if [[ $? -gt 0 ]] #If new violation has happened from last checkpoint then add it to message.
	then
		echo "SOFT CPU TIME VIOLATION" >> $DIR/message
		/usr/bin/awk '{print $5"\t"$9}' $DIR/diffop | /usr/bin/sort | /usr/bin/uniq -c >> $DIR/message
		sendmail=1
	fi

	/sbin/aureport -x --failed --summary  -i -if /var/log/audit/audit.log > $DIR/currop
	#Check the for the system calls that has failed.Take the diffs of the current and previous output to see whether a new violation has happened from last check point.
	/usr/bin/diff -N --suppress-common-lines $DIR/currop $DIR/prevop > $DIR/diffop 
	if [[ $? -eq 0 ]] #If no new violation has happened from last checkpoint then exit.
	then
		finish $sendmail
		exit
	fi
	sendmail=1

	#If there is fsize violation add it to message.
	/sbin/ausearch  -k fsize -sv no -if /var/log/audit/audit.log  > $DIR/currfsizelog
	/usr/bin/diff -N --suppress-common-lines $DIR/currfsizelog $DIR/prevfsizelog > $DIR/diffop
	if [[ $? -gt 0 ]] 
	then
		echo "FILE SIZE VIOLATION" >> $DIR/message
		/usr/bin/awk '{if($2=="type=SYSCALL"){printf $16"\t";print $27}}' $DIR/diffop | /usr/bin/sort | /usr/bin/uniq -c >> $DIR/message
	fi

	#If there is a noproc violation add it to message.
	/sbin/ausearch  -k noproc -sv no -if /var/log/audit/audit.log > $DIR/currnoproclog
	/usr/bin/diff -N --suppress-common-lines $DIR/currnoproclog $DIR/prevnoproclog > $DIR/diffop
	if [[ $? -gt 0 ]] 
	then
		echo "PROCESS NUMBER VIOLATION" >> $DIR/message
		/usr/bin/awk '{if($2=="type=SYSCALL"){printf $16"\t";print $27}}' $DIR/diffop | /usr/bin/sort | /usr/bin/uniq -c >> $DIR/message
	fi

	#If there is a nofile violation add it to message.
	/sbin/ausearch  -k nofile -sv no -if /var/log/audit/audit.log > $DIR/currnofilelog
	/usr/bin/diff -N --suppress-common-lines $DIR/currnofilelog $DIR/prevnofilelog > $DIR/diffop
	if [[ $? -gt 0 ]] 
	then
		echo "NUMBER OF FILES VIOLATION" >> $DIR/message
		/usr/bin/awk '{if($2=="type=SYSCALL"){printf $16"\t";print $27}}' $DIR/diffop | /usr/bin/sort | /usr/bin/uniq -c  >> $DIR/message
	fi

	#If there is a memlock violation add it to message.
	/sbin/ausearch  -k memlock -sv no -if /var/log/audit/audit.log > $DIR/currmemlocklog
	/usr/bin/diff -N --suppress-common-lines $DIR/currmemlocklog $DIR/prevmemlocklog > $DIR/diffop
	if [[ $? -gt 0 ]] 
	then
		echo "MEMLOCK VIOLATION" >> $DIR/message
		/usr/bin/awk '{if($2=="type=SYSCALL"){printf $16"\t";print $27}}' $DIR/diffop |/usr/bin/sort |/usr/bin/uniq -c  >> $DIR/message
	fi

	#Now the report is in message file.We will be sending the mail with message as body.
	finish $sendmail
}

main
