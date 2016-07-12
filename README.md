# robotraider
Simple script that retrieves the robots.txt file an opens disallowed pages

Robots.txt files sometime contain interesting information. During a penetration test we usually check the links mentioned as "disallow" on robots.txt files as these are the files that are trying to be hidden from search engines. 
We usually run into login pages, older versions of the website or even strange and unsecured web services. 

This script performs a host query first and tries to pull the robots.txt file. 
If successful it will open all disallowed (e.g. links they don't want search engines to know about) links on seperate tabs in Iceweasel. 

This script was tested on Kali and Ubuntu Linux

The name was inspired by Douglas Berdeaux's book "Raiding the Wireless Empire"
