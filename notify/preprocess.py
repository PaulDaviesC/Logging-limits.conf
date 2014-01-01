import sys
import subprocess
import os
def main():
	fp = open(sys.argv[1])
	num_logs = int(sys.argv[4])
	if int(sys.argv[3]) == 0:
		for line in fp:
			logarray = line.split(' ')
			sys.stdout.write("%s %s %s %s" %(logarray[3],logarray[4], logarray[7], logarray[8]))
			selectlogline(sys.argv[2],int(logarray[7].split('=')[1]), float(logarray[2].split('(')[1].split(':')[0]), num_logs)
	elif int(sys.argv[3]) == 1:
		for line in fp:
			logarray = line.split(' ')
			sys.stdout.write("%s %s %s %s %s" %(logarray[14],logarray[15],logarray[13], logarray[25], logarray[26]))
			selectlogline(sys.argv[2],int(logarray[13].split('=')[1]), float(logarray[2].split('(')[1].split(':')[0]), num_logs)
def selectlogline(filename ,pid, ts, num_logs):
	for i in range (0, num_logs):
		found = 0
		if i:
			filename = "/var/log/audit/audit.log.%d" %(i)
		else:
			filename = "/var/log/audit/audit.log"
		afp = open(filename)
		prevline = ""
		for i, line in enumerate(afp):
			if line.startswith("type=SYSCALL") and "key=\"noproc\"" in line and "exit=%d" %(pid) in line :
				logarray = line.split(' ')
				currts = float(logarray[1].split('(')[1].split(':')[0])
				if currts <= ts :
					prevline = line
					found = 1
		if found :
			logarray = prevline.split(' ')
			print(" Time Stamp=%f parent_%s parent_%s" %(currts, logarray[24], logarray[25]))
			break;
if __name__ == "__main__":
	main()
