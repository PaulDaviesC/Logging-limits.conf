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
