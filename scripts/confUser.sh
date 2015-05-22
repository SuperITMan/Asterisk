#!/bin/bash
# Script permettant la modification d'utilisateur sur Asterisk
# 

asteriskDir="/etc/asterisk"

#---------------------------------------------------Personal functions----------------------------------------------------#
function sorryMessage ()
{
	echo "-----------------------------------------------------"
	echo "L'application etant encore dans sa version beta, vous devez encore realiser certaines taches a la main."
	echo "L'application sera mise a jour prochainement."
	echo "-----------------------------------------------------"
}

function customPassword ()
{
	read -p "Desirez-vous attribuer un mot de passe personnalise pour l'utilisateur ? ([O]ui ou [N]on) : " -n1 isCustomPwd
	while [ $isCustomPwd != "n" ] && [ $isCustomPwd != "N" ] && [ $isCustomPwd != "o" ] && [ $isCustomPwd != "O" ];
	do
	echo "Choix invalide! Veuillez recommencer."
	read -p "Desirez-vous attribuer un mot de passe personnalise pour l'utilisateur ? ([O]ui ou [N]on) : " -n1 isCustomPwd
	done
	
	echo ""
	
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

function checkNoUser () 
{
	if [ "$1" -lt 10 ]
	then
		idUserCall="0$1"
	else
		idUserCall="$1"
	fi
}

function addUser ()
{
	sorryMessage
	echo "Veuillez lire le fichier de config ci-apres et noter le numero que devra porter le $1. <$2XX> (Exemple : 1 ou 2 ou 11 ou 23 ou ...)"
	echo "Si un numero est libre (par ex : ""$2""01 pris, ""$2""03 pris mais ""$2""02 non pris), noter ce numero comme etant le no de l'utilisateur"
	echo "Pour quitter la lecture du fichier, appuyez sur \"Ctrl\" + \"X\" puis, s'il vous est demande s'il faut sauver, taper \"n\""
	read -p "Appuyez sur n'importe quelle touche pour commencer la lecture du fichier..." -n1
	
	if [ -f "$asteriskDir"/sip.conf ]; then
	nano "$asteriskDir"/sip.conf
	read -p "Veuillez taper le numero que l'utilisateur : " noUser
	fi
	
	checkNoUser $noUser
	
	echo "Veuillez modifier le fichier de config ci-apres et ajouter les lignes ci-dessous sous [$4]."
	echo "================================================================"
	echo ";$5 $noUser"
	echo ";Dial $203 to call $5 $noUser, if not available: Voicemail"
	echo "exten => $2$idUserCall,1,Dial(, 15)"
	echo "same => n,VoiceMail($2$idUserCall@site2)"
	echo "same => n,Hangup()"
	echo "================================================================"
	echo "Il vous est conseille de copier ces lignes sur votre ordinateur pour les coller par la suite."
	echo "Pour quitter la modification du fichier, appuyez sur \"Ctrl\" + \"X\" puis, s'il vous est demande s'il faut sauver, taper \"y\" pour confirmer."
	read -p "Appuyez sur n'importe quelle touche pour commencer l'edition du fichier..." -n1
	
	if [ -f "$asteriskDir"/extensions.conf ]; then
	nano "$asteriskDir"/extensions.conf
	echo "Vos modifications ont ete sauvegardees"
	fi
	
	printf "$2$idUserCall => 1234,$3$noUser\n" >> "$asteriskDir"/voicemail.conf

	customPassword "$3" $noUser
	echo "Mot de passe utilisateur : "$pwdUser
	
	checkNoUser $noUser
}

function editUser ()
{
	sorryMessage
	echo "Veuillez modifier les informations concernant l'utilisateur de votre choix dans le fichier de configuration."
	echo "Pensez à chercher [$3X] pour trouver l'utilisateur a modifier."
	echo "Pour quitter la lecture du fichier, appuyez sur \"Ctrl\" + \"X\" puis, s'il vous est demande s'il faut sauver, taper \"y\" pour sauvegarder vos modifications."
	read -p "Appuyez sur n'importe quelle touche pour ouvrir le fichier..." -n1
	
	if [ -f "$asteriskDir"/sip.conf ]; then
	nano "$asteriskDir"/sip.conf
	fi
	
	echo "Veuillez modifier le fichier de config ci-apres et supprimer les lignes concernant l'utilisateur. Elles ressemblent aux lignes ci-dessous en fonction du numéro de l'utilisateur."
	echo "================================================================"
	echo ";$5 XX"
	echo ";Dial $203 to call $5 XX, if not available: Voicemail"
	echo "exten => $2XX,1,Dial(, 15)"
	echo "same => n,VoiceMail($2XX@site2)"
	echo "same => n,Hangup()"
	echo "================================================================"
	echo "Il vous est conseille de copier ces lignes sur votre ordinateur pour les coller par la suite."
	echo "Pour quitter la modification du fichier, appuyez sur \"Ctrl\" + \"X\" puis, s'il vous est demande s'il faut sauver, taper \"y\" pour confirmer."
	read -p "Appuyez sur n'importe quelle touche pour commencer l'edition du fichier..." -n1
	
	if [ -f "$asteriskDir"/extensions.conf ]; then
	nano "$asteriskDir"/extensions.conf
	echo "Vos modifications ont ete sauvegardees"
	fi
	
	echo "Veuillez modifier le fichier de config ci-apres et modifier la ligne concernant l'utilisateur. Elle ressemble a la ligne ci-dessous en fonction du numero de l'utilisateur."
	echo "================================================================"
	echo "$2XX => 1234,$3XX"
	echo "================================================================"
	echo "Il vous est conseille de copier ces lignes sur votre ordinateur pour les coller par la suite."
	echo "Pour quitter la modification du fichier, appuyez sur \"Ctrl\" + \"X\" puis, s'il vous est demande s'il faut sauver, taper \"y\" pour confirmer."
	read -p "Appuyez sur n'importe quelle touche pour commencer l'edition du fichier..." -n1
	
	if [ -f "$asteriskDir"/voicemail.conf ]; then
	nano "$asteriskDir"/voicemail.conf
	echo "Vos modifications ont ete sauvegardees"
	fi
	
	asterisk -rx "reload"
	echo "Vos modifications ont ete effectuees."
	read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
}

function deleteUser ()
{
	sorryMessage
	echo "Veuillez supprimer les informations concernant l'utilisateur de votre choix dans le fichier de configuration."
	echo "Pensez à chercher [$3X] pour trouver l'utilisateur a supprimer."
	echo "Pour supprimer l'utilisateur, vous devez tout ce qui se trouve en dessous de [$3X] jusqu'a la \"[\" suivante."
	echo "Pour quitter la lecture du fichier, appuyez sur \"Ctrl\" + \"X\" puis, s'il vous est demande s'il faut sauver, taper \"y\" pour sauvegarder vos modifications."
	read -p "Appuyez sur n'importe quelle touche pour ouvrir le fichier..." -n1
	
	if [ -f "$asteriskDir"/sip.conf ]; then
	nano "$asteriskDir"/sip.conf
	fi
	
	echo "Veuillez modifier le fichier de config ci-apres et supprimer les lignes concernant l'utilisateur. Elles ressemblent aux lignes ci-dessous en fonction du numero de l'utilisateur."
	echo "================================================================"
	echo ";$5 XX"
	echo ";Dial $203 to call $5 XX, if not available: Voicemail"
	echo "exten => $2XX,1,Dial(, 15)"
	echo "same => n,VoiceMail($2XX@site2)"
	echo "same => n,Hangup()"
	echo "================================================================"
	echo "Il vous est conseille de copier ces lignes sur votre ordinateur pour les coller par la suite."
	echo "Pour quitter la modification du fichier, appuyez sur \"Ctrl\" + \"X\" puis, s'il vous est demande s'il faut sauver, taper \"y\" pour confirmer."
	read -p "Appuyez sur n'importe quelle touche pour commencer l'edition du fichier..." -n1
	
	if [ -f "$asteriskDir"/extensions.conf ]; then
	nano "$asteriskDir"/extensions.conf
	echo "Vos modifications ont ete sauvegardees"
	fi
	
	echo "Veuillez modifier le fichier de config ci-apres et supprimer la ligne concernant l'utilisateur. Elle ressemble a la ligne ci-dessous en fonction du numero de l'utilisateur."
	echo "================================================================"
	echo "$2XX => 1234,$3XX"
	echo "================================================================"
	echo "Il vous est conseille de copier ces lignes sur votre ordinateur pour les coller par la suite."
	echo "Pour quitter la modification du fichier, appuyez sur \"Ctrl\" + \"X\" puis, s'il vous est demande s'il faut sauver, taper \"y\" pour confirmer."
	read -p "Appuyez sur n'importe quelle touche pour commencer l'edition du fichier..." -n1
	
	if [ -f "$asteriskDir"/voicemail.conf ]; then
	nano "$asteriskDir"/voicemail.conf
	echo "Vos modifications ont ete sauvegardees"
	fi
	
	asterisk -rx "reload"
	echo "Vos modifications ont ete effectuees."
	read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
}
#------------------------------------------------End of personal functions------------------------------------------------#

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
			while :
			do
			clear
cat<<EOF
==============================================================
                   Ajout d'un utilisateur                
==============================================================
Veuillez choisir le profil de l'utilisateur a ajouter

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
				addUser "nouveau commercial" "4" "com" "callComs" "Commercial"
				
				printf "[com"$noUser"](coms)\nusername=com"$noUser"\ncallerid=""Commercial "$noUser""" <4"$idUserCall">\nfullname=""Commercial "$noUser"""\nsecret="$pwdUser"\n\n" >> /etc/asterisk/sip.conf
				
				asterisk -rx "reload"
				
				echo "Utilisateur rajoute ! Info user : username=com"$noUser
				read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
				break
			;;
			
			#Profil installateur
			"2") 
				addUser "nouvel installateur" "5" "inst" "callInsts" "Installateur"
				
				printf "[inst"$noUser"](insts)\nusername=inst"$noUser"\ncallerid=""Installateur "$noUser""" <5"$idUserCall">\nfullname=""Installateur "$noUser"""\nsecret="$pwdUser"\n\n" >> /etc/asterisk/sip.conf
				
				asterisk -rx "reload"
				
				echo "Utilisateur rajoute ! Info user : username=inst"$noUser
				read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
				break
			;;
		
			#Profil support technique
			"3") 
				addUser "nouveau support technique" "3" "suptech" "callSupTechs" "Support Technique"
				
				printf "[suptech"$noUser"](suptechs)\nusername=suptech"$noUser"\ncallerid=""Supp Tech "$noUser""" <3"$idUserCall">\nfullname=""Support Technique "$noUser"""\nsecret="$pwdUser"\n\n" >> /etc/asterisk/sip.conf
				
				asterisk -rx "reload"
				
				echo "Utilisateur rajoute ! Info user : username=suptech"$noUser
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
			done
		;;

		#Modification d'un utilisateur
		"2")
			while :
			do
			clear
cat<<EOF
==============================================================
               Modification d'un utilisateur                
==============================================================
Veuillez choisir le profil de l'utilisateur a modifier

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
				editUser "nouveau commercial" "4" "com" "callComs" "Commercial"
				break
			;;
			#Profil installateur
			"2")
				editUser "nouvel installateur" "5" "inst" "callInsts" "Installateur"
				break
			;;
			#Profil support technique
			"3")
				editUser "nouveau support technique" "3" "suptech" "callSupTechs" "Support Technique"
				break
			;;
			
			"Q")
			break ;;
		
			"q") 
			break ;;
		
			 * )  echo "Choix invalide !"     ;;
			
			esac 
			sleep 1
			done 
		;;
		
		#Suppression d'un utilisateur
		"3")
			while :
			do
			clear
cat<<EOF
==============================================================
               Suppression d'un utilisateur                
==============================================================
Veuillez choisir le profil de l'utilisateur a supprimer

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
				deleteUser "nouveau commercial" "4" "com" "callComs" "Commercial"
				break
			;;
			#Profil installateur
			"2")
				deleteUser "nouvel installateur" "5" "inst" "callInsts" "Installateur"
				break
			;;
			#Profil support technique
			"3")
				deleteUser "nouveau support technique" "3" "suptech" "callSupTechs" "Support Technique"
				break
			;;
			
			"Q")
			break ;;
		
			"q") 
			break ;;
		
			 * )  echo "Choix invalide !"     ;;
			
			esac 
			sleep 1
			done ;;
		
		
		"Q")
		break ;;
	
		"q") 
		break ;;
	
		 * )  echo "Choix invalide !"     ;;
		
		esac 
		sleep 1
		done