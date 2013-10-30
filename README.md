The Problem
============

Linux provides a mechanism to cap the resources of users by specifying the rules in the /etc/security/limits.conf. Using this facility , some of the resources that can be capped are:

* Core file size (core).
* Size of the heap (data).
* Size of the file that can be opened (fsize).
* Maximum locake in memory address space (memlock).
* Number of files that can be kept open (nofile).
* Size of the stack(stack).
* Maximum CPU time (cpu).
* Maximum number of processes (nproc).
* Address space limit (as).

Unfortunately no logging facility has been provided with the limits.conf. So this project intends to solve the logging issue by making use of some tools and may be some tweaking.

Proposed Solution
=================

One of the things that may happen when a resources allocation fails is system call failure. When a system call fails , the Linux kernel sets an approriate errno value and returns the system call. For example if the process requests the Kernel to allocate memory space through mmap sytem call , and if there is no memory space to allocated then the mmap fails and errno is set to ENOMEM. If we could detect such failed system calls based on their function and the errno , then we can have a hint about which resource limit has been violated.

The answer to monitoring the system calls in a Linux system is the **audit subsytem**. The audit subsytem works at the Kernel level and comes with user space tools like **auditctl** , **ausearch** and **aureport**. The auditctl helps us to add rules, ausearch to search in the log file and aureport to get breif reports on the log.

Here I will list the system calls and their corresponding errno numbers to be tracked. I will also be mentioning the audit rules that has too be specified.

#### Maximum Number of Processes (noproc)

|System call|ERRNO |
--- | ---
fork() | EAGAIN
clone() | EAGAIN
vfork() | EAGAIN

##### Rules
* auditctl -a exit,always -S clone -F exit=-EAGAIN -F success=0 -k noproc
* auditctl -a exit,always -S fork -F exit=-EAGAIN -F success=0 -k noproc
* auditctl -a exit,always -S vfork -F exit=-EAGAIN -F success=0 -k noproc

#### Maximum Number of open files (nofile)

|System call|ERRNO |
--- | ---
open() | EMFILE

##### Rules
* auditctl -a exit,always -S open -F exit=-EMFILE -F success=0 -k nofile


#### Maximum locked in memory (memlock)

|System call|ERRNO |
--- | ---
open() | EMFILE

##### Rules
* auditctl -a exit,always -S open -F exit=-EMFILE -F success=0 -k nofile

#### Need for tracking setrlimit and plrimit

The process may request for the the raising the current limits imposed using setrlimit(). However that request can fail due to the hard limit imposed on a resource in limits.conf. So we need to track failed the setrlimit(). The resource it requested must have to be deduced from the value of a0(the first argument to setrlimit) , which is logged by the audit. 

Similarly we will also be tracking the failed prlimit system calls. It can be used to both set and get the resource limits of an arbitrary process.

|System call|ERRNO |
--- | ---
setrlimit() | EINVAL
setrlimit() | EPERM
plrlimit() | EINVAL
plrlimit() | EPERM
