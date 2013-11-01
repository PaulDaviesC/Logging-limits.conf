The Problem
============

Linux provides a mechanism to cap the resources of users by specifying the rules in the /etc/security/limits.conf.Unfortunately no logging facility has been provided with the limits.conf. This project intends to solve the logging issue by making use of auditd.

The rules are specified in the rules.sh file. Run that file to add the required rules to audit system.

Rules in Action
===============

After adding the required rules by running the *rules.sh* the violations can be listed using *ausearch*. The limit name and the corresponding command to list the violations has been listed below.

* noproc : **ausearch -k noproc**
* fsize : **ausearch -k fsize**
* nofile : **ausearch -k nofile**


Testing
=======
In order to test the validity of rules kindly refer to tests/README.md.

How it works
============

Read the DOC.md file.
