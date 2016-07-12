#!/bin/bash

clear
echo 
echo -n "Please enter Domain name (format: domain.com): "
echo
read domain
break="========================================"
#check for empty domain name
if [ -z $domain ];then
	echo "You did not enter a domain name."
	exit
fi
echo
echo "Starting host command for" $domain
echo
echo $break
echo  
host $domain
echo
echo $break
echo
echo "Searching for robots.txt file on " $domain
echo 
#checks if could get robots.txt
wget $domain/robots.txt 2>/dev/null
if [[ "$?" != 0 ]]; then
	echo "Error downloading file"
	exit	
else
	echo "Success"
fi
echo
echo $break
echo
echo
echo "Processing robots.txt file"

#found it was easier to create the file first on Ubuntu
touch ~/Desktop/robotsfile.txt

#gets the disallowed links
cat robots.txt | grep "Disallow" | cut -d "/" -f 2 >> ~/Desktop/robotsfile.txt

#turns out you have to start Firefox first to make sure all tabs are fine
firefox &
sleep 3
for i in $(cat ~/Desktop/robotsfile.txt); do
	firefox -new-tab $domain/$i &
	sleep 1

done
