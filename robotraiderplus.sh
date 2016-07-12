#!/bin/bash
# RobotRaider partly by Alper Basaran (2016)
# Code mostly by Weaknetlabs Douglas Berdeaux
version="0.1"
export IFS=$'\n'
break="========================================"
function intro {
	clear
	printf "\nRobotRaider v$version (2016) - Alper Basaran\n"
	printf "\nCode mostly by WeakNet Labs  - Douglas Berdeaux\n\n"
}
function getDomain { 
	regexp="[a-zA-Z0-9_-]\.[a-zA-Z]\.[a-zA-Z]"; #works with domains such as co.uk, co.il or com.tr but not .fr, .tk and the like
	printf "Please enter Domain name (format: domain.com): "
	read domain
	#check for empty domain name
	if [ -z $domain ];then
		printf "You did not enter a domain name.\n"
		getDomain
	elif ! egrep -q '^[a-zA-Z0-9_-]+\.[a-zA-Z]+\.[a-zA-Z]+$' <<< $domain; then
		printf "That was not a domain name.\n";
		getDomain
	fi
}
intro;
getDomain;
if [[ -f "$domain-robots.txt" ]];then
	rm $domain-robots.txt # get rid of prevoius file
fi
printf "\nStarting $(which host) command for $domain\n$break\n";
$(which host) $domain
printf "\n$break\nSearching for robots.txt file on $domain\n"

robotLines=($(curl -s http://$domain/robots.txt))
if [[ "$?" != 0 ]]; then
	printf "Could not find a robots.txt file at $domain.\n"
	exit	
else
	echo "Success!"
fi # fall through okay here:
printf "$break\nProcessing robots.txt file.\n"

touch $domain-robots.txt # log the results
for i in ${robotLines[@]}; do
	if egrep -q "Disallow" <<< "$i";then # only if it has a Disallow line
		echo "$i" |tee -a $domain-robots.txt
	fi
done;

#gets the disallowed links
sed -i -re 's/[^\/]+(\/[^\/]+\/).*/\1/' $domain-robots.txt
firefox=$(which firefox)
if [[ "$?" != 0 ]];then
	printf "You Don't have Firefox installed. Exiting.\n"
	exit 1;
else
	printf "Shall I start a Firefox session with each link in a new tab? [y/n]: ";
	read ans;
	if [ "$ans" = "y" ]; then # they want to!
	 printf "Starting Firefox with $firefox.\n";
		firefox & # Warning! untested area below!
		sleep 3;
		for i in $(cat $domain-robots.txt); do
			firefox -new-tab $domain$i &
			sleep 1
		done
	fi
fi

unset IFS; # reset this
