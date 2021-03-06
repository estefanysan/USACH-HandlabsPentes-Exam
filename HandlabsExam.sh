#!/bin/bash

ETC_HOSTS=/etc/hosts

# Help List #
show_help() {
    echo "Local PentestLab Docker based"
    echo "Mode of use: ./HandlabsExam.sh (start|stop|status|info|list} [projectname]" >&2
    echo "This script use docker and hosts alias to make vulnerable web apps available on localhost"
    echo "some examples of use are:"
    echo " ./HandlabsExam.sh start nowasp   - Start project and make it available on localhost"
	echo " ./HandlabsExam.sh stop nowasp    - Stop project available on localhost"
    echo " ./HandlabsExam.sh status        - Show status for all projects"
    echo " ./HandlabsExam.sh info nowasp    - Show information about Nowasp project"
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
echo "OWASP Mutillidae II is a free, open source, deliberately vulnerable web-application"
echo "providing a target for web-security enthusiest. Mutillidae can be installed on Linux and"
echo "Windows using LAMP, WAMP, and XAMMP. It is pre-installed on SamuraiWTF, Rapid7"
echo "Metasploitable-2, and OWASP BWA. The existing version can be updated on these"
echo "platforms. With dozens of vulns and hints to help the user; this is an easy-to-use web"
echo "hacking environment designed for labs, security enthusiast, classrooms, CTF, and"
echo "vulnerability assessment tool targets. Mutillidae has been used in graduate security courses,"
echo "corporate web sec training courses, and as an assess the assessor target for vulnerability"
echo "assessment software"
}
project_startinfo_nowasp () 
{
echo "https://github.com/webpwnized/mutillidae/"
echo "Remember to click on the create database link before you start"
}

project_info_owasp-bricks () 
{
echo "Bricks is a web application security learning platform built on PHP and MySQL."
echo "The project focuses on variations of commonly seen application security issues."
echo "Each 'Brick' has some sort of security issue which can be leveraged manually or using automated software tool"
echo "The mission is to 'Break the Bricks' and thus learn the various aspects of web application security"

echo "https://github.com/gildasio/docker-bricks"
}
project_startinfo_owasp-bricks () 
{
echo "Please see the documentation https://sechow.com/bricks/docs/"
}

project_info_bwapp () 
{
echo "bWAPP, or a buggy web application, is a free and open source deliberately insecure web application"
echo "It helps security enthusiasts, developers and students to discover and to prevent web vulnerabilities."
echo "bWAPP prepares one to conduct successful penetration testing and ethical hacking projects."
echo "bWAPP is a PHP application that uses a MySQL database. It can be hosted on Linux/Windows with Apache/IIS"
echo "and MySQL. It can also be installed with WAMP or XAMPP."
echo "Another possibility is to download the bee-box, a custom Linux VM pre-installed with bWAPP"
}
project_startinfo_bwapp ()
{
echo "http://www.itsecgames.com"
}

project_info_wackopicko () 
{
echo "WackoPicko is a website written by Adam Doup??. It contains known and common vulnerabilities (XSS vulnerabilities,"
echo "SQL injections, command-line injections, sessionID vulnerabilities, file inclusions, parameters manipulation, ...)."
echo "It was first used for the paper Why Johnny Can't Pentest: An Analysis of Black-box Web Vulnerability Scanners."
echo "WackoPicko has been developed as a *real* web application with following features:"
echo "Authentication: WackoPicko provides personalized content to registered users."
echo "Upload Pictures: When a photo is uploaded to WackoPicko by a registered user, other users can comment on it, as well as purchase the right to a high-quality version."
echo "Comment On Pictures: Once a picture is uploaded into WackoPicko, all registered users can comment on the photo by ???lling out a form."
echo "Purchase Pictures: A registered user on WackoPicko can purchase the high-quality version of a picture."
echo "Search: The search feature offers the possibility to filter pictures by looking for strings in the tags of the images"
echo "Guestbook: A guestbook page provides a way to receive feedback from all visitors to the WackoPicko web site."
echo "Admin Area: WackoPicko has a special area for administrators only, which enables the creation of new users."

}
project_startinfo_wackopicko () 
{
echo "https://www.aldeid.com/wiki/WackoPicko"
}

project_info_vulnerablewordpress () 
{
echo "https://github.com/wpscanteam/VulnerableWordpress"
echo "Vulnerable Wordpress Application"
echo "support technologies like PHP and MySQL"
}
project_startinfo_vulnerablewordpress () 
{
  echo "WPScan Vulnerable Wordpress site now awailable at localhost on http://127.13.0.1"
}

project_info_securityninjas () 
{
echo "This hands-on training lab consists of 10 fun real world like hacking exercises, corresponding to each of the OWASP"
echo "Top 10 vulnerabilities. Hints and solutions are provided along the way. Although the backend for this is written in"
echo "PHP, vulnerabilities would remain the same across all web based languages, so the training would still be relevant"
echo "even if you don???t actively code in PHP."
}
project_startinfo_securityninjas ()
{
  echo "Open DNS Security Ninjas site now available at localhost on http://127.14.0.1"
  echo "for more information, please consult https://github.com/opendns/Security_Ninjas_AppSec_Training"
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
  echo "Docker mapped to http://$ip"
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
  if [ "$(sudo docker ps -q -f name=nowasp)" ]; then
    echo "Nowasp running at http://127.15.0.1"
  else 
    echo "Nowasp not running"
  fi
  if [ "$(sudo docker ps -q -f name=owasp-bricks)" ]; then
    echo "Owasp-Bricks	running at http://127.10.0.1"
  else 
    echo "Owasp-Bricks	not running"  
  fi
  if [ "$(sudo docker ps -q -f name=bwapp)" ]; then
    echo "bWapp	running at http://127.5.0.1"
  else 
    echo "bWapp	not running"  
  fi
  if [ "$(sudo docker ps -q -f name=wackopicko)" ]; then
    echo "WackoPicko running at http://127.0.0.1"
  else 
    echo "WackoPicko not running"  
  fi
  if [ "$(sudo docker ps -q -f name=vulnerablewordpress)" ]; then
    echo "WPScan Vulnerable Wordpress running at http://127.13.0.1"
  else 
    echo "WPScan Vulnerable Wordpress not running"  
  fi
  if [ "$(sudo docker ps -q -f name=securityninjas)" ]; then
    echo "OpenDNS Security Ninjas 	running at http://127.14.0.1"
  else 
    echo "OpenDNS Security Ninjas	not running"  
  fi
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
