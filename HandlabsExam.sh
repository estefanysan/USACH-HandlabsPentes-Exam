#!/bin/bash

ETC_HOSTS=/etc/hosts

# Listado de Ayuda #
help() {
    echo "Local PentestLab Management Script (Docker based)"
    echo
    echo "Usage: $0 {list|status|info|start|stop} [projectname]" >&2
    echo
    echo " This scripts uses docker and hosts alias to make web apps available on localhost"
    echo 
    echo " Ex."
    echo " $0 list"
    echo " 	List all available projects"
    echo " $0 status"
    echo "	Show status for all projects"
    echo " $0 start bwapp"
    echo " 	Start project and make it available on localhost" 
    echo " $0 info bwapp"
    echo " 	Show information about bwapp project"
    echo
    echo " Dockerfiles from:"
    echo "  DVWA                   - Ryan Dewhurst (vulnerables/web-dvwa)"
    echo "  Mutillidae II          - Nikolay Golub (citizenstig/nowasp)"
    echo "  bWapp                  - Rory McCune (raesene/bwapp)"
    echo "  Webgoat(s)             - OWASP Project"
    echo "  NodeGoat		   - Ben McMahon (bjm243/nodegoat)"
    echo "  Juice Shop             - Bjoern Kimminich (bkimminich/juice-shop)"
    echo "  Vulnerable Wordpress   - WPScan Team (l505/vulnerablewordpress)"
    echo "  Security Ninjas        - OpenDNS Security Ninjas AppSec Training"
    exit 1
}
help
#Prueba de modificacion 23453