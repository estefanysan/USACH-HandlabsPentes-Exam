#!/bin/bash

ETC_HOSTS=/etc/hosts

# Help List #
Help() {
    echo "Local PentestLab Docker based"
    echo "Mode of use: ./HandlabsExam.sh (start|stop|status|info|list} [projectname]" >&2
    echo "This script use docker and hosts alias to make vulnerable web apps available on localhost"
    echo "some examples of use are:"
    echo " ./HandlabsExam.sh start bwapp - Start project and make it available on localhost"
	echo " ./HandlabsExam.sh stop bwapp - Stop project available on localhost"
    echo " ./HandlabsExam.sh status - Show status for all projects"
    echo " ./HandlabsExam.sh info bwapp - Show information about bwapp project"
	echo " ./HandlabsExam.sh list - List all available projects"
	echo
    echo " Dockerfiles from:"
    echo "  bWapp                  - Rory McCune (raesene/bwapp)"
    echo "  Webgoat(s)             - OWASP Project"
    echo "  Vulnerable Wordpress   - WPScan Team (l505/vulnerablewordpress)"
    echo "  Security Ninjas        - OpenDNS Security Ninjas AppSec Training"
    exit 1
}


#Check Docker status (Instaled/running)#

if ! [ -x "$(command -v docker)" ]; then
  echo 
  echo "Docker not found. You need install docker before running this script."
  echo "For kali linux you can install docker with the following command:"
  echo "  apt install docker.io"
  exit
fi

if sudo service docker status | grep inactive > /dev/null
then 
	echo "Docker is not running."
	echo -n "Do you want to start docker now (y/n)?"
	read answer
	if echo "$answer" | grep -iq "^y"; then
		sudo service docker start
	else
		echo "Not starting. Script will not be able to run applications."
	fi
fi

#List vulnerable apps#
list() {
    echo "Available pentest applications" >&2
    echo "  bwapp 		- bWAPP PHP/MySQL based from itsecgames.com"
    echo "  webgoat7		- WebGoat 7.1 OWASP Flagship Project"
    echo "  webgoat8		- WebGoat 8.0 OWASP Flagship Project"
    echo "  vulnerablewordpress	- WPScan Vulnerable Wordpress"
    echo "  securityninjas	- OpenDNS Security Ninjas"
    echo
    exit 1

}
list
#Info dispatch#
info () {
  case "$1" in 
    bwapp)
      project_info_bwapp
      ;;
    webgoat7)
      project_info_webgoat7
      ;;
    webgoat8)
      project_info_webgoat8      
      ;;
    vulnerablewordpress)
      project_info_vulnerablewordpress
    ;;
    securityninjas)
      project_info_securityninjas
    ;;
    *) 
      echo "Unknown project name"
      ;;
  esac  
}
info
#Project Info#
project_info_bwapp () 
{
echo "http://www.itsecgames.com"
}
project_info_webgoat7 () 
{
echo "https://www.owasp.org/index.php/Category:OWASP_WebGoat_Project"
}
project_info_webgoat8 () 
{
echo "  https://www.owasp.org/index.php/Category:OWASP_WebGoat_Project"
}
project_info_vulnerablewordpress () 
{
echo "https://github.com/wpscanteam/VulnerableWordpress"
}
project_info_securityninjas () 
{
echo "https://github.com/opendns/Security_Ninjas_AppSec_Training"
}

# Main switch case#
case "$1" in
  # start)
    # if [ -z "$2" ]
    # then
      # echo "ERROR: Option start needs project name in lowercase"
      # echo 
      # list # call list ()
      # break
    # fi
    # project_start_dispatch $2
    # ;;
  # stop)
    # if [ -z "$2" ]
    # then
      # echo "ERROR: Option stop needs project name in lowercase"
      # echo 
      # list # call list ()
      # break
    # fi
    # project_stop_dispatch $2
    # ;;
  list)
    list # call list ()
    ;;
  # status)
    # project_status # call project_status ()
    # ;;
  info)
    if [ -z "$2" ]
    then
      echo "ERROR: Option info needs project name in lowercase"
      echo 
      list # call list ()
      break
    fi
    info $2
    ;;
  *)
   Help
;;
esac  

#Prueba de modificacion 23453
