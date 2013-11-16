#!/bin/bash
#Here the different rules to be added are specified.
#If you want to clear all the rules just use auditctl -D command.

#noproc rules. noproc caps the number of processes spawned by a single process.
auditctl -a exit,always -S clone -F exit=-EAGAIN -F success=0 -k noproc
auditctl -a exit,always -S fork -F exit=-EAGAIN -F success=0 -k noproc
auditctl -a exit,always -S vfork -F exit=-EAGAIN -F success=0 -k noproc

#fsize rules. fsize caps the maximum size of the file that can written by a process.
auditctl -a exit,always -S write -F exit=-EFBIG -F success=0 -k fsize

#nofile rules. nofile caps the number of files that can be kept open by a process simultaneously.
auditctl -a exit,always -S open -F exit=-EMFILE -F success=0 -k nofile

#memlock rules. memlock caps the maximum amount of memory that a process can have in the primary memory. 

auditctl -a exit,always -S mlock -F exit=-ENOMEM -F success=0 -k memlock
auditctl -a exit,always -S mlockall -F exit=-ENOMEM -F success=0 -k memlock
auditctl -a exit,always -S munlock -F exit=-ENOMEM -F success=0 -k memlock
auditctl -a exit,always -S munlockall -F exit=-ENOMEM -F success=0 -k memlock

#data rules. data caps the maximum amount of heap a process can take

auditctl -a exit,always -S mmap -F exit=-ENOMEM -F success=0 -k data
auditctl -a exit,always -S mmap2 -F exit=-ENOMEM -F success=0 -k data
auditctl -a exit,always -S munmap -F exit=-ENOMEM -F success=0 -k data
auditctl -a exit,always -S brk -F exit=-ENOMEM -F success=0 -k data
