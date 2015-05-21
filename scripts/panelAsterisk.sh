#!/bin/bash
# Script permettant l'installation d'Asterisk sur un serveur Debian nu
# 

#asteriskDir = "/etc/asterisk"

#apt-get update -q && apt-get upgrade -y
#apt-get install asterisk -y
#apt-get install curl -y
#apt-get install -y build-essential

cd /tmp

#Téléchargement des scripts sur github
wget https://raw.githubusercontent.com/SuperITMan/Asterisk/master/scripts/confSIP.sh -O confSIP.sh
wget https://raw.githubusercontent.com/SuperITMan/Asterisk/master/scripts/confIax.sh -O confIax.sh
wget https://raw.githubusercontent.com/SuperITMan/Asterisk/master/scripts/installAsterisk.sh -O installAsterisk.sh
wget https://raw.githubusercontent.com/SuperITMan/Asterisk/master/scripts/reinstallAsterisk.sh -O reinstallAsterisk.sh
wget https://raw.githubusercontent.com/SuperITMan/Asterisk/master/scripts/confUser.sh -O confUser.sh

#Attribution des droits nécessaires à l'exécution des scripts
chmod +x reinstallAsterisk.sh
chmod +x confIax.sh
chmod +x confSIP.sh
chmod +x confUser.sh

while :
do
	clear
cat<<EOF
==============================================================
			   Installation Asterisk & Add-Ons                
==============================================================
Veuillez choisir votre option

	[1] Installation d'Asterisk
		- iax, sip, extensions, voicemail, iptables
	[2] Réinstallation d'Asterisk
		- sauvegarde de l'installation, réinstallation
	[3] Modification d'un utilisateur
		- ajout, édition, suppression d'un ou plusieurs utilisateurs
	[4] Modification des extensions
		- modification du dialplan d'Asterisk
	[5] Modification du voicemail
		- modifications des voicemails des utilisateurs
	[6] Modification de l'IAX
		- modification de la gestion de l'IAX
	
	[Q]uitter le script
	
--------------------------------------------------------------

EOF

	read -n1 choice
	
	case "$choice" in
	
	#Installation d'Asterisk
	"1")
		ping -q -c3 8.8.8.8
		pingTest=$?
		if [ $pingTest -ne 0 ]
		then
			echo "Il semble que vous ne soyez pas connecté à internet."
			echo "Merci de vérifier votre connexion et de recommencer ensuite."
			read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
			
		elif [-d /etc/asterisk ]
		then
			echo "Asterisk est déjà installé sur cet ordinateur."
			echo "Veuillez choisir l'option \"Réinstallation d'Asterisk\"."
			read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
		else 		
			./installAsterisk.sh
		fi ;;
		
	#Réinstallation d'Asterisk
	"2")
		ping -q -c3 8.8.8.8
		pingTest=$?
		if [ $pingTest -ne 0 ]
			then
				echo "Il semble que vous ne soyez pas connecté à internet."
				echo "Merci de vérifier votre connexion et de recommencer ensuite."
				read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
				
			else 
				if [ -d /etc/asterisk ];
					then						
						./reinstallAsterisk.sh
					else
						echo "Il semble qu'Asterisk ne soit pas installé sur cet ordinateur."
						echo "Veuillez choisir l'option 1 pour une installation d'Asterisk"
						read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
				fi
		fi;;
		
	# Modification d'un utilisateur
	"3")
		./confUser.sh
	;;
	
	"Q")
		exit ;;
	
	"q") 
		exit ;;
	
	 * )  echo "Choix invalide ! "$choice     ;;

	esac
    sleep 1

done