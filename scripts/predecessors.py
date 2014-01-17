import sys, subprocess, os, decimal
num_logs = 4
def main():
	sys.stdout.write("Given process's ");
	getcmdline(int(sys.argv[1]), decimal.Decimal(sys.argv[2]))
	print ' '
	printparents(int(sys.argv[1]), float(sys.argv[2]))
def getcmdline(pid, ts):
	p = subprocess.Popen('ausearch -k exec -p %d'%(pid), shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	lines = str(p.communicate()[0]).split('\n');
	i=0
	cmdline = ''
	try:
		while ts >= decimal.Decimal(lines[i*7+5].split(' ')[1].split('(')[1].split(':')[0]):
			cmdline = lines[i*7+5];
			cwdline = lines[i*7+4];
			i = i + 1
	except:
		pass
	try:
		cmdlist = cmdline.split(' ')
		argc = int(cmdlist[2].split('=')[1])
		sys.stdout.write("command line = \"");
		for i in range(3, 3+argc):
			sys.stdout.write("%s " %(cmdlist[i].split('=')[1][1:-1]));
		sys.stdout.write("\"");
	except:
		pass
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
				#print currpid
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
				getcmdline(int(pid.split('=')[1]), currts)
				print("%s Time Stamp=%.3f parent_%s parent_%s" %(pid, currts, parent_exe, parent_comm))
				printparents(int(pid.split('=')[1]), logts)
				break;
		except:
			pass
if __name__ == "__main__":
	main()
