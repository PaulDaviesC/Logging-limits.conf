#!/bin/bash
#Here the different rules to be added are specified.
#If you want to clear all the rules just use auditctl -D command.

#noproc rules. noproc caps the number of processes spawned by a single process.
auditctl -a exit,always -S clone -k noproc 
auditctl -a exit,always -S fork -k noproc
auditctl -a exit,always -S vfork -k noproc

#fsize rules. fsize caps the maximum size of the file that can written by a process.
auditctl -a exit,always -S write -F exit=-EFBIG -F success=0 -k fsize

#nofile rules. nofile caps the number of files that can be kept open by a process simultaneously.
auditctl -a exit,always -S open -F exit=-EMFILE -F success=0 -k nofile

#memlock rules. memlock caps the maximum amount of memory that a process can have in the primary memory. 

auditctl -a exit,always -S mlock -F exit=-ENOMEM -F success=0 -k memlock
auditctl -a exit,always -S mlockall -F exit=-ENOMEM -F success=0 -k memlock
auditctl -a exit,always -S munlock -F exit=-ENOMEM -F success=0 -k memlock
auditctl -a exit,always -S munlockall -F exit=-ENOMEM -F success=0 -k memlock
auditctl -a exit,always -S mmap -F exit=-EAGAIN -F success=0 -k memlock

#as rules. as caps the maximum amount of virtual address space a process can take

auditctl -a exit,always -S mmap -F exit=-ENOMEM -F success=0 -k as
auditctl -a exit,always -S mmap2 -F exit=-ENOMEM -F success=0 -k as
auditctl -a exit,always -S munmap -F exit=-ENOMEM -F success=0 -k as
auditctl -a exit,always -S brk -F exit=-ENOMEM -F success=0 -k as

#We are observing the setrlimit and prlimit system calls to see whether they
#lead to any hits.
auditctl -a exit,always -S setrlimit -F exit=-EINVAL -F success=0 -k rlimit
auditctl -a exit,always -S setrlimit -F exit=-EPERM -F success=0 -k rlimit
