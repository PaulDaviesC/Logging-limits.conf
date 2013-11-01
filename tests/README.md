You must run the rules.sh file before start testing.The steps to run the tests are explained here.

Testing noproc violation logging
--------------------------------
1 Complile and run tests/noproc.c.
2 Use **ausearch -k noproc** to list the violation.

Testing fsize violation logging
-------------------------------
1  Copy a file ,with greater size than specified in the limits.conf, using cp from one location to other.
2  Use **ausearch -k fsize** to list the violation.

Testing nofile violation logging
--------------------------------
1  Compile and run tests/nofile.c
2  Use **ausearch -k nofile** to list the violation.
