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
wget -q https://raw.githubusercontent.com/SuperITMan/Asterisk/master/scripts/confSIP.sh -O confSIP.sh
wget -q https://raw.githubusercontent.com/SuperITMan/Asterisk/master/scripts/confIax.sh -O confIax.sh
wget -q https://raw.githubusercontent.com/SuperITMan/Asterisk/master/scripts/installAsterisk.sh -O installAsterisk.sh
wget -q https://raw.githubusercontent.com/SuperITMan/Asterisk/master/scripts/reinstallAsterisk.sh -O reinstallAsterisk.sh
wget -q https://raw.githubusercontent.com/SuperITMan/Asterisk/master/scripts/confUser.sh -O confUser.sh
wget -q https://raw.githubusercontent.com/SuperITMan/Asterisk/master/scripts/confExtensions.sh -O confExtensions.sh

#Attribution des droits nécessaires à l'exécution des scripts
chmod +x installAsterisk.sh
chmod +x reinstallAsterisk.sh
chmod +x confIax.sh
chmod +x confSIP.sh
chmod +x confUser.sh
chmod +x confExtensions.sh

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
	[2] Reinstallation d'Asterisk
		- sauvegarde de l'installation, reinstallation
	[3] Modification d'un utilisateur
		- ajout, edition, suppression d'un ou plusieurs utilisateurs
	[4] Modification des extensions
		- modification du dialplan d'Asterisk
	[5] Modification du voicemail
		- modifications des voicemails des utilisateurs
	[6] Modification de l'IAX
		- modification de la gestion de l'IAX
	
	[Q]uitter le script
	
--------------------------------------------------------------

EOF

	read -n1 -s choice
	
	case "$choice" in
	
	#Installation d'Asterisk
	"1")
		echo "Vérification de votre connexion internet"
		ping -q -c3 8.8.8.8
		pingTest=$?
		if [ $pingTest -ne 0 ]
		then
			echo "Il semble que vous ne soyez pas connecte a internet."
			echo "Merci de verifier votre connexion et de recommencer ensuite."
			read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
			
		elif [-d /etc/asterisk ]
		then
			echo "Vérification de votre connexion internet : fait!"
			echo "Asterisk est deja installe sur cet ordinateur."
			echo "Veuillez choisir l'option \"Reinstallation d'Asterisk\"."
			read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
		else 		
			echo "Vérification de votre connexion internet : fait!"
			./installAsterisk.sh
		fi ;;
		
	#Réinstallation d'Asterisk
	"2")
		echo "Vérification de votre connexion internet"
		ping -q -c3 8.8.8.8
		pingTest=$?
		if [ $pingTest -ne 0 ]
			then
				echo "Il semble que vous ne soyez pas connecte a internet."
				echo "Merci de verifier votre connexion et de recommencer ensuite."
				read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
				
			else 
				if [ -d /etc/asterisk ];
					then						
						echo "Vérification de votre connexion internet : fait!"
						./reinstallAsterisk.sh
					else
						echo "Vérification de votre connexion internet : fait!"
						echo "Il semble qu'Asterisk ne soit pas installe sur cet ordinateur."
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