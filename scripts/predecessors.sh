#predecessors.sh is used to get the details of the all possible predecessors
#that has been logged in the audit log. It takes input as the PID and TIME
#STAMP that you got in the notification mail.
function getParent
{
	/sbin/ausearch -e $1 -k clone | grep 'type=SYSCALL' >$DIR/op
	nolines=`cat $DIR/op | wc -l`
	j=1;
	#Select the right log line of the argument process so that we can get the parent process id.
	while [ $j -le $nolines ]
	do
		i=`tail -n $j $DIR/op | head -n 1`
				if [[ $2 -ge $TS ]]
		then
			echo
			echo -------Child of-------
			echo
			echo `echo $i | cut -d ' ' -f14` `echo $i | cut -d ' ' -f15` `echo $i | cut -d ' ' -f25`  `echo $i | cut -d ' ' -f26`
			getParent `echo $i | cut -d ' ' -f13| cut -d '=' -f2` `echo $i| cut -d ' ' -f2 | cut -d '.' -f1 | cut -d '(' -f2`
			break
		else
			let "j=$j+1"
		fi
	done 
}
function main
{
	if [[ $# -ne 2 ]]
	then
		echo "Wrong usage. Usage : predeccessors.sh [PID] [Time Stamp]"
		exit
	fi
	getParent $1 $2
}
main $1 $2
