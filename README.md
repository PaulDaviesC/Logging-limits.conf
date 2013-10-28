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
