#!/bin/bash

ETC_HOSTS=/etc/hosts

# Help List #
show_help() {
    echo "Local PentestLab Docker based"
    echo "Mode of use: ./HandlabsExam.sh (start|stop|status|info|list} [projectname]" >&2
    echo "This script use docker and hosts alias to make vulnerable web apps available on localhost"
    echo "some examples of use are:"
    echo " ./HandlabsExam.sh start bwapp   - Start project and make it available on localhost"
	echo " ./HandlabsExam.sh stop bwapp    - Stop project available on localhost"
    echo " ./HandlabsExam.sh status        - Show status for all projects"
    echo " ./HandlabsExam.sh info bwapp    - Show information about bwapp project"
	echo " ./HandlabsExam.sh list          - List all available projects"
	echo
    echo " Dockerfiles from:"
	echo " Nowasp                 - Citizenstig (citizenstig/nowasp)"
	echo " Owasp Bricks           - gjuniioor/owasp-bricks"
    echo " bWapp                  - Rory McCune (raesene/bwapp)"
    echo " WackoPicko             - Vulnerable Website"
    echo " Vulnerable Wordpress   - WPScan Team (l505/vulnerablewordpress)"
    echo " Security Ninjas        - OpenDNS Security Ninjas AppSec Training"
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
	echo "  nowasp				- OWASP Mutillidae II Web Pen-Test Practice Application"
	echo "  owasp-bricks		- OWASP Bricks"
    echo "  bwapp 				- bWAPP PHP/MySQL based from itsecgames.com"
    echo "  wackopicko			- WackoPicko Vulnerable Website"
    echo "  vulnerablewordpress	- WPScan Vulnerable Wordpress"
    echo "  securityninjas		- OpenDNS Security Ninjas"
    echo
    exit 1

}

#Info dispatch#
info () {
  case "$1" in 
	nowasp)
      project_info_nowasp
    ;;
	owasp-bricks)
      project_info_owasp-bricks
    ;;
    bwapp)
      project_info_bwapp
      ;;
	wackopicko)
      project_info_wackopicko
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
	  list
      ;;
  esac  
}

#hosts file#
function removehost() {
    if [ -n "$(grep $1 /etc/hosts)" ]
    then
        echo "Removing $1 from $ETC_HOSTS";
        sudo sed -i".bak" "/$1/d" $ETC_HOSTS
    else
        echo "$1 was not found in your $ETC_HOSTS";
    fi
}

function addhost() { # ex.   127.5.0.1	bwapp
    HOSTS_LINE="$1\t$2"
    if [ -n "$(grep $2 /etc/hosts)" ]
        then
            echo "$2 already exists in /etc/hosts"
        else
            echo "Adding $2 to your $ETC_HOSTS";
            sudo -- sh -c -e "echo '$HOSTS_LINE' >> /etc/hosts";

            if [ -n "$(grep $2 /etc/hosts)" ]
                then
                    echo -e "$HOSTS_LINE was added succesfully to /etc/hosts";
                else
                    echo "Failed to Add $2, Try again!";
            fi
    fi
}

#Project Info#
project_info_nowasp () 
{
echo "https://github.com/citizen-stig/dockermutillidae"
}
project_info_owasp-bricks () 
{
echo "https://github.com/gildasio/docker-bricks"
}
project_info_bwapp () 
{
echo "http://www.itsecgames.com"
}
project_info_wackopicko () 
{
echo "https://www.aldeid.com/wiki/WackoPicko"
}
project_info_vulnerablewordpress () 
{
echo "https://github.com/wpscanteam/VulnerableWordpress"
}
project_info_securityninjas () 
{
echo "https://github.com/opendns/Security_Ninjas_AppSec_Training"
}

#Start#
project_start ()
{
  fullname=$1		  # ex. Nowasp
  projectname=$2      # ex. nowasp
  dockername=$3  	  # ex. citizenstig/nowasp
  ip=$4   			  # ex. 127.15.0.1
  port=$5			  # ex. 80
  port2=$6			  # second port binding (Optional)
  
  echo "Starting $fullname"
  addhost "$ip" "$projectname"


  if [ "$(sudo docker ps -aq -f name=$projectname)" ]; 
  then
    echo "Running command: docker start $projectname"
    sudo docker start $projectname
  else
    if [ -n "${6+set}" ]; then
      echo "Running command: docker run --name $projectname -d -p $ip:80:$port -p $ip:$port2:$port2 $dockername"
      sudo docker run --name $projectname -d -p $ip:80:$port -p $ip:$port2:$port2 $dockername
    else echo "not set";
      echo "Running command: docker run --name $projectname -d -p $ip:80:$port $dockername"
      sudo docker run --name $projectname -d -p $ip:80:$port $dockername
    fi
  fi
  echo "DONE!"
  echo
  echo "Docker mapped to http://$projectname or http://$ip"
  echo
}

#Stop#
project_stop ()
{
  fullname=$1		 # ex. Nowasp
  projectname=$2     # ex. nowasp

  echo "Stopping... $fullname"
  echo "Running command: docker stop $projectname"
  sudo docker stop $projectname
  removehost "$projectname"
}

project_status()
{
  fullname=$1		 # ex. Nowasp
  projectname=$2     # ex. nowasp

  if [ "$(sudo docker ps -q -f name=$projectname)" ]; then
    echo "$fullname	running at http://ip"
  else 
    echo "$fullname	not running"
  fi
  # if [ "$(sudo docker ps -q -f name=owasp-bricks)" ]; then
    # echo "Owasp Bricks	running at http://ip"
  # else 
    # echo "Owasp Bricks	not running"
  # fi
  # if [ "$(sudo docker ps -q -f name=bwapp)" ]; then
    # echo "bWaPP				running at http://ip"
  # else 
    # echo "bWaPP				not running"
  # fi
  # if [ "$(sudo docker ps -q -f name=bwapp)" ]; then
    # echo "WackoPicko				running at http://ip"
  # else 
    # echo "WackoPicko				not running"
  # fi
  # if [ "$(sudo docker ps -q -f name=vulnerablewordpress)" ]; then
    # echo "WPScan Vulnerable Wordpress 	running at http://vulnerablewordpress"
  # else 
    # echo "WPScan Vulnerable Wordpress	not running"  
  # fi
  # if [ "$(sudo docker ps -q -f name=securityninjas)" ]; then
    # echo "OpenDNS Security Ninjas 	running at http://securityninjas"
  # else 
    # echo "OpenDNS Security Ninjas	not running"  
  # fi
}

project_start_dispatch()
{
  case "$1" in
	nowasp)    
      project_start "Nowasp" "nowasp" "citizenstig/nowasp" "127.15.0.1" "80"
      project_startinfo_nowasp
    ;;
	owasp-bricks)    
      project_start "Owasp Bricks" "owasp-bricks" "gjuniioor/owasp-bricks" "127.10.0.1" "80"
      project_startinfo_owasp-bricks
    ;;
    bwapp)
      project_start "bWAPP" "bwapp" "raesene/bwapp" "127.5.0.1" "80"
      project_startinfo_bwapp
    ;;
	wackopicko)
      project_start "WackoPicko" "wackopicko" "adamdoupe/wackopicko" "127.0.0.1" "80" "8080"
      project_startinfo_bwapp
    ;;
    vulnerablewordpress)
      project_start "WPScan Vulnerable Wordpress" "vulnerablewordpress" "l505/vulnerablewordpress" "127.13.0.1" "80" "3306"
      project_startinfo_vulnerablewordpress
    ;;
    securityninjas)    
      project_start "Open DNS Security Ninjas" "securityninjas" "opendns/security-ninjas" "127.14.0.1" "80"
      project_startinfo_securityninjas
    ;;
    *)
    echo "ERROR: Project dispatch doesn't recognize the project name" 
    ;;
  esac  
}

project_stop_dispatch()
{
  case "$1" in
	
	nowasp)
      project_stop "Nowasp" "nowasp"
    ;;
	owasp-bricks)
      project_stop "Owasp Bricks" "owasp-bricks"
    ;;
    bwapp)
      project_stop "bWAPP" "bwapp"
    ;;
	wackopicko)
      project_stop "WackoPicko" "wackopicko"
    ;;
    vulnerablewordpress)
      project_stop "WPScan Vulnerable Wordpress" "vulnerablewordpress"
    ;;
    securityninjas)
      project_stop "Open DNS Security Ninjas" "securityninjas"
    ;;
    *)
    echo "ERROR: Project dispatch doesn't recognize the project name" 
    ;;
  esac  
}


# Main switch case#
case "$1" in
  start)
    if [ -z "$2" ]
    then
      echo "ERROR: Option start needs project name in lowercase"
      echo 
      list # call list ()
      break
    fi
    project_start_dispatch $2
    ;;
  stop)
    if [ -z "$2" ]
    then
      echo "ERROR: Option stop needs project name in lowercase"
      echo 
      list # call list ()
      break
    fi
    project_stop_dispatch $2
    ;;
  list)
    list # call list ()
    ;;
  status)
    project_status # call project_status ()
    ;;
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
   show_help
;;
esac  

#Prueba de modificacion 23453
