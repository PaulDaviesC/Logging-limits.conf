Predecessors 
============

Some times the information of immediate parent may not be that useful and we
need to gather the details of the processes which are higher up in the process
tree. The **predecessor.sh** can be used exactly for that purpose. The 
notification mail lists the for each violation  PID of the process that caused
the violation and a time stamp. The predecessors.sh take the arguments as
the PID and the time stamp and lists all possible predecessors with immediate
predecessor first. 
#### Sample Output

Command : **sudo bash predecessors.sh 12378 1388630455.801**

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
user-creation.s and the latters parent is ruby.
