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

#### Maximum Number of Processes

|System call|ERRNO |
--- | ---
fork() | EAGAIN
clone() | EAGAIN
vfork() | EAGAIN
