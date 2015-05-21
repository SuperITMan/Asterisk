#!/bin/bash
# Script permettant la modification d'utilisateur sur Asterisk
# 

asteriskDir="/etc/asterisk"

function customPassword ()
{
	read -p "Désirez-vous attribuer un mot de passe personnalisé pour l'utilisateur ? ([O]ui ou [N]on) : " -n1 isCustomPwd
	while [ $isCustomPwd != "n" ] && [ $isCustomPwd != "N" ] && [ $isCustomPwd != "o" ] && [ $isCustomPwd != "O" ];
	do
	echo "Choix invalide! Veuillez recommencer."
	read -p "Désirez-vous attribuer un mot de passe personnalisé pour l'utilisateur ? ([O]ui ou [N]on) : " -n1 isCustomPwd
	#echo "Désirez-vous attribuer un mot de passe personnalisé pour l'utilisateur ? ([O]ui ou [N]on)"
	#read -n1 -s isCustomPwd
	done
	
	if [ $isCustomPwd == "O" ] || [ $isCustomPwd == "o" ] 
	then 		
		echo "Veuillez entrer le mot de passe : "
		read -s pwdUser
		echo "Veuillez entrer une 2e fois le mot de passe : "
		read -s pwdUser2
		while [ "$pwdUser" != "$pwdUser2" ]
		do
			echo "Erreur! Les mots de passe ne correspondent pas. Veuillez recommencer."
			echo "Veuillez entrer le mot de passe : "
			read -s pwdUser
			echo "Veuillez entrer une 2e fois le mot de passe : "
			read -s pwdUser2
		done
		
	else 
		pwdUser=$1""$2
	fi
}

while :
	do
	clear
cat<<EOF
==============================================================
               Modification d'un utilisateur                
==============================================================
Veuillez choisir votre option

	[1] Ajout d'un utilisateur
		- choix profil, attribution mot de passe
	[2] Modification d'un utilisateur
		- modification profil, mot de passe
	[3] Suppression d'un utilisateur
		- suppression du profil
	
	[Q]uitter la modification d'un utilisateur
	
--------------------------------------------------------------

EOF

	read -n1 -s choice1
	case "$choice1" in
	
		#Ajout d'un utilisateur
		"1")
			while true;
			do
			clear
cat<<EOF
==============================================================
                   Ajout d'un utilisateur                
==============================================================
Veuillez choisir le profil de l'utilisateur à ajouter

	[1] Profil commercial
		- 
	[2] Profil installateur
		- 
	[3] Profil support technique
		- 
	
	[Q]uitter l'ajout d'utilisateur
	
--------------------------------------------------------------

EOF
			read -n1 -s profileChoice
			case "$profileChoice" in
			#Profil commercial
			"1") 
				echo "Veuillez lire le fichier de config ci-après et noter le numéro que devra porter le nouveau commercial. <4XX> (Exemple : 01 ou 02 ou 11 ou ...)"
				echo "Pour quitter la lecture du fichier, appuyez sur \"Ctrl\" + \"X\" puis, s'il vous est demandé s'il faut sauver, taper \"n\""
				
				if [ -f "$asteriskDir"/sip.conf ]; then
				nano "$asteriskDir"/sip.conf
				read -p "Veuillez taper le numéro que l'utilisateur : " noUser
				#noUser=$?
				fi
				
				customPassword "com" $noUser
				echo "Mot de passe utilisateur : "$pwdUser
				printf "[com"$noUser"](insts)\nusername=com"$noUser"\ncallerid=""Commercial "$noUser""" <40"$noUser">\nfullname=""Commercial "$noUser"""\nsecret="$pwdUser >> /etc/asterisk/sip.conf
				
				echo "Utilisateur rajouté ! Info user : username=com"$noUser
				read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
				break
			;;
			
			#Profil installateur
			"2") 
				echo "Veuillez lire le fichier de config ci-après et noter le numéro que devra porter le nouvel installateur. <5XX> (Exemple : 01 ou 02 ou 11 ou ...)"
				echo "Pour quitter la lecture du fichier, appuyez sur \"Ctrl\" + \"X\" puis, s'il vous est demandé s'il faut sauver, taper \"n\""
				
				if [ -f "$asteriskDir"/sip.conf ]; then
				nano "$asteriskDir"/sip.conf
				read -p "Veuillez taper le numéro que l'utilisateur : " noUser
				#noUser=$?
				fi
				
				customPassword "inst" $noUser
				echo "Mot de passe utilisateur : "$pwdUser
				printf "[inst"$noUser"](insts)\nusername=inst"$noUser"\ncallerid=""Installateur "$noUser""" <50"$noUser">\nfullname=""Installateur "$noUser"""\nsecret="$pwdUser >> /etc/asterisk/sip.conf
				asterisk -rx "reload"
				
				echo "Utilisateur rajouté ! Info user : username=inst"$noUser
				read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
				break
			;;
		
			#Profil support technique
			"3") 
				echo "Veuillez lire le fichier de config ci-après et noter le numéro que devra porter le nouveau support technique. <3XX> (Exemple : 01 ou 02 ou 11 ou ...)"
				echo "Pour quitter la lecture du fichier, appuyez sur \"Ctrl\" + \"X\" puis, s'il vous est demandé s'il faut sauver, taper \"n\""
				
				if [ -f "$asteriskDir"/sip.conf ]; then
				nano "$asteriskDir"/sip.conf
				read -p "Veuillez taper le numéro que l'utilisateur : " noUser
				#noUser=$?
				else
				echo "il y a un problème : $asteriskDir/sip.conf"
				fi
				
				customPassword "suptech" $noUser
				echo "Mot de passe utilisateur : "$pwdUser
				printf "[suptech"$noUser"](insts)\nusername=suptech"$noUser"\ncallerid=""Supp Tech "$noUser""" <50"$noUser">\nfullname=""Support Technique "$noUser"""\nsecret="$pwdUser >> /etc/asterisk/sip.conf
				
				echo "Utilisateur rajouté ! Info user : username=suptech"$noUser
				read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
				break
			;;
			
			"Q")
			break ;;
		
			"q") 
			break ;;
		
			 * )  echo "Choix invalide !"     ;;
			
			esac
			sleep 1
			done;;

		#Modification d'un utilisateur
		"2") break;;
			
		"Q")
		break ;;
	
		"q") 
		break ;;
	
		 * )  echo "Choix invalide !"     ;;
		
		esac 
		sleep 1
		done
		
