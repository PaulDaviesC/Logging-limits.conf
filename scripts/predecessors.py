import sys
import subprocess
import os
num_logs = 4
def main():
	printparents(int(sys.argv[1]), float(sys.argv[2]))
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
					logts = float(logarray[1].split('(')[1].split(':')[0])
					if logts <= currts :
						prevline = line
						found = 1
			if found :
				logarray = prevline.split(' ')
				print("------Child of-------");
				parent_exe = [x for x in logarray if "exe=" in x][0]
				parent_comm = [x for x in logarray if "comm=" in x][0]
				pid = [x for x in logarray if "pid=" in x][1]
				print("%s Time Stamp=%.3f parent_%s parent_%s" %(pid, currts, parent_exe, parent_comm))
				printparents(int(pid.split('=')[1]), logts)
				break;
		except:
			pass
if __name__ == "__main__":
	main()
