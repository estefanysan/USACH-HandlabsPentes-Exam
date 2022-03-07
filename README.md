# USACH-HandlabsPentes-Exam
Final test USACH Handlabs Pentesting

Bash script created to manage vulnerable web apps with dockers. The Bash was created for Kali-linux distributions.
The follow are the available web apps: 

## Vulnerable web Apps: 

* Nowasp
* Owasp Bricks
* bWapp
* Wacko Picko
* WPScan Vulnerable Wordpress
* Security Ninjas

## Getting Started

1. git clone https://github.com/estefanysan/USACH-HandlabsPentes-Exam

2. cd HandlabsExam.sh

If you have not installed docker on your x64 Kali system
you can run this script (tested as of Jul 2019)
Note: I always add a regular user and login with it 
before actually using kali, so sudo is added in all scripts
./install_docker_kali_x64.sh

## Then run
./HandlabsExam.sh start Nowasp
... to download Nowasp (Or any other web app) docker image and map it onto localhost at http://ip (IP = IP assigned to the service)

## Print a complete list of available projects use the list command
./HandlabsExam.sh list 

## Print help info and usage
./HandlabsExam.sh show_help
