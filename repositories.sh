#!/bin/bash

# Debian PPA Utility - Utility which allows you to add PPA's on Debian.
# It adds "add-apt-repository" binary which allows you to add PPA's. 
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# add copyright
# author, etc

# Root checker
if [[ $EUID -ne 0 ]]; then
	echo -e "\n---------------------------------------\n"
    echo -e "add-apt-repository: must be run as root" 1>&2
    echo -e "\n---------------------------------------\n"
	exit 1
fi

# action
if [ $# -eq 1 ]
NM=`uname -a && date`
NAME=`echo $NM | md5sum | cut -f1 -d" "`
then
	ppa_name=`echo "$1" | cut -d":" -f2 -s`
	if [ -z "$ppa_name" ]
	then
		echo -e "\n------------------------------------------\n"
		echo -e "PPA name parameter missing!\n"
		echo -e "Correct syntax:"
		echo -e "sudo add-apt-repository ppa:user/ppa-name"
		echo -e "\n------------------------------------------\n"	
	else

	# validate PPA existance
	ppa_usr=`echo $ppa_name | grep -oE "[^:]+$" | cut -d':' -f1 | cut -d'/' -f1`
	ppa_pkg=`echo $ppa_name | grep -oE "[^/]+$"`

	status=$(curl -s --head -w %{http_code} https://launchpad.net/~$ppa_usr/+archive/ubuntu/$ppa_pkg -o /dev/null)

	if [ $status == "200" ]
	then
		echo -e "\n-----------------------------------\n"
		echo -e "Adding \"$ppa_name\" PPA ... "
		echo -e "\n-----------------------------------\n"
	else
		echo -e "\n---------------------------------------------\n"
		echo -e "PPA not found!\n"
		echo -e "Check spelling? \"ppa:$ppa_name"\"
		echo -e "\n---------------------------------------------\n"
			
		exit 1
	fi

		# /etc/apt/sources.d/ppa_name.list file creation
        ppa_d_name=`echo $ppa_name | grep -oE "[^/]+$"`
        ppd_d=/etc/apt/sources.list.d/$ppa_d_name.list
        touch $ppd_d

		# detect codename
		if [ "$(lsb_release -cs)" == "wheezy" ];
		then
    		codename=precise

		elif [ "$(lsb_release -cs)" == "sid" ];
		then
			codename=trusty

		elif [ "$(lsb_release -cs)" == "jessie" ]; 
		then
    		codename=trusty

		else 
    		echo "Unsupported Debian version \(>= Wheezy only\)"
			exit 1
		fi
	
		# Add PPA
		echo "$ppa_name"
		echo "deb http://ppa.launchpad.net/$ppa_name/ubuntu $codename main" > $ppd_d
		apt-get update >> /dev/null 2> /tmp/${NAME}_apt_add_key.txt
		key=`cat /tmp/${NAME}_apt_add_key.txt | cut -d":" -f6 | cut -d" " -f3`
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $key
		rm -rf /tmp/${NAME}_apt_add_key.txt

	# print result
	echo -e "\n------------------------------------------------------------"
	echo -e "\nPPA \"$ppa_name\" added: $ppd_d"
	echo -e "\n------------------------------------------------------------"

	fi

else
	echo "Utility to add PPA repositories in your debian machine"
	echo "$0 ppa:user/ppa-name"
fi
