#!/bin/bash
aureport --key --summary > currop
diff currop prevop > /dev/null
if [[ $? -gt 0 ]]
then
	#Write the code to send mail here
fi
cp currop prevop
