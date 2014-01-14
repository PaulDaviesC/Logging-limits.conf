Predecessors 
============

Some times the information of immediate parent may not be that useful and we
need to gather the details of the processes which are higher up in the process
tree. The **predecessor.py** can be used exactly for that purpose. The 
notification mail lists the for each violation  PID of the process that caused
the violation and a time stamp\*. The predecessors.py take the arguments as
the PID and the time stamp and lists all possible predecessors with immediate
predecessor first. 

\* Note : A process can only be uniquely identified by a PID and a time stamp.
It can never be uniquely identified by the PID alone. The reason is that the
PID is only unique during its life time. Then after a process dies out, its
PID can be allocated to another process.

#### Sample Output

Command : **sudo python predecessors.py 12378 1388630455.801**

#####Output

-------Child of-------

pid=12365 auid=0 uid=0 comm="adduser" exe="/usr/bin/perl" Time_Stamp=1388630455.801

-------Child of-------

pid=12362 auid=0 uid=0 comm="user-creation.s" exe="/bin/bash" Time_Stamp=1388630452.089

-------Child of-------

pid=12719 auid=0 uid=0 comm="ruby" exe="/usr/local/rvm/rubies/ruby-1.9.3-p194/bin/ruby" Time_Stamp=1388630452.081

#####Interpretation of Output

The above output can be interpreted as :The immediate parent of 12378 with
time stamp ts 1388630455.801 is the command adduser. The parent of adduser is
user-creation.s and the latters parent is ruby. The auid in each line refers
to the login id ( uid at login time) of the user who ran the command and uid
 refers to the uid of the user when the command was executed.

####How it works?

Linux by default does not log any details about the processes that are
created. However we can make the Linux do it by making use of the audit
system. The idea is to track the fork(),clone and vclone() system calls. The
audit system logs the exit value whenever it logs a system call. The exit
value of the process creation system calls is the PID of the new process that
is created.

Whenever we have an input PID  P and time stamp TS , we search for the appropriate
log line from the end of the log, with exit value of process creation system
calls as P  and TS >= time stamp in the audit log. Whenever we find the log
line we output the details in the log line which is that of the argument
processes parent. Now we give the input as the parent process and find its
parent. We continue this process until as far as we can go.
