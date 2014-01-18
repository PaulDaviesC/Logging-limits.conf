import sys, subprocess, os, decimal
def get_num_logs():
	fp = open("/etc/audit/auditd.conf");
	for i in fp.readlines():
		if i.startswith("num_logs ="):
			return int(i.split("=")[1])
	fp.close()
num_logs=get_num_logs()
def main():
	sys.stdout.write("Given process's ");
	getcmdline(int(sys.argv[1]), decimal.Decimal(sys.argv[2]))
	print ' '
	printparents(int(sys.argv[1]), float(sys.argv[2]))
def getcmdline(pid, ts):
	sys.stdout.write("command line=\"");
	p = subprocess.Popen('ausearch -k exec -p %d'%(pid), shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	lines = str(p.communicate()[0]).split('\n');
	cmdline = ''
	try:
		for i in lines:
			if i.startswith('type=EXECVE') and ts >= decimal.Decimal(i.split(' ')[1].split('(')[1].split(':')[0]):
				cmdline = i;
		cmdlist = cmdline.split(' ')
		argc = int(cmdlist[2].split('=')[1])
		for i in range(3, 3+argc):
			sys.stdout.write("%s " %(cmdlist[i].split('=')[1][1:-1]));
	except :
		pass
	sys.stdout.write("\""); #This line was added due to bug in the audit logging. argc is wrong at times.
def printparents(pid, ts):
	currpid = pid	
	currts = ts
	for i in range (0, num_logs):
		found = 0
		if i:
			filename = "/var/log/audit/audit.log.%d" %(i)
		else:
			filename = "/var/log/audit/audit.log"
		try:
			afp = open(filename)
			prevline = ""
			for i, line in enumerate(afp):
				if line.startswith("type=SYSCALL") and "key=\"noproc\"" in line and "exit=%d" %(currpid) in line :
					logarray = line.split(' ')
					logts = decimal.Decimal(logarray[1].split('(')[1].split(':')[0])
					if logts <= currts :
						prevline = line
						found = 1
			if found :
				logarray = prevline.split(' ')
				print("------Child of-------");
				parent_exe = [x for x in logarray if "exe=" in x][0]
				parent_comm = [x for x in logarray if "comm=" in x][0]
				pid = [x for x in logarray if "pid=" in x][1]
				uid = [x for x in logarray if "uid=" in x][1]
				auid = [x for x in logarray if "auid=" in x][0]
				getcmdline(int(pid.split('=')[1]), logts)
				print(" %s %s %s  Time Stamp=%.3f parent_%s parent_%s" %(pid, uid, auid, currts, parent_exe, parent_comm))
				printparents(int(pid.split('=')[1]), logts)
				break;
		except:
			pass
if __name__ == "__main__":
	main()
