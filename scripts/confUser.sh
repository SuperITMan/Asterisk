#!/bin/bash
# Script permettant la modification d'utilisateur sur Asterisk
# 

while true;
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

	read -n1 -s
	case $choice1 in
	
		#Ajout d'un utilisateur
		"1")
			while true;
			do
			clear
cat<<EOF
==============================================================
			   Modification d'un utilisateur                
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
			read -n1 -s
			case $profileChoice in
			#Profil commercial
			"1") ;;
			
			#Profil installateur
			"2") ;;
		
			#Profil support technique
			"3") ;;
			
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