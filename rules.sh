#!/bin/bash
#noproc rules. noproc caps the number of processes spawned by a single process
auditctl -a exit,always -S clone -F exit=-EAGAIN -F success=0 -k noproc
auditctl -a exit,always -S fork -F exit=-EAGAIN -F success=0 -k noproc
auditctl -a exit,always -S vfork -F exit=-EAGAIN -F success=0 -k noproc
