#!/bin/bash
#noproc rules. noproc caps the number of processes spawned by a single process.
auditctl -a exit,always -S clone -F exit=-EAGAIN -F success=0 -k noproc
auditctl -a exit,always -S fork -F exit=-EAGAIN -F success=0 -k noproc
auditctl -a exit,always -S vfork -F exit=-EAGAIN -F success=0 -k noproc
#fsize rules. fsize caps the maximum size of the file that can written by a process.
auditctl -a exit,always -S write -F exit=-EFBIG -F success=0 -k fsize
