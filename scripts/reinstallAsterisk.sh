#!/bin/bash
#Script permettant la réinstallation d'Asterisk

VERT="\\033[1;32m"
ROUGE="\\033[1;31m"
NORMAL="\\033[0;39m"

asteriskDir="/etc/asterisk"
backupDir="/etc/asterisk/backupConf"
tempBackupDir="/tmp/backupAsterisk"

echo -ne "Arret du service Asterisk ... :\r"
/etc/init.d/asterisk stop
echo -ne "Arret du service Asterisk ... : ""$VERT""fait.""$NORMAL""\r"
sleep 2

echo ""

#Sauvegarde des fichiers de confIax
echo -ne "Sauvegarde des fichiers de configuration dans $tempBackupDir ... :\r"

if [ ! -d "$tempBackupDir" ]; then
mkdir "$tempBackupDir"
fi

cp "$asteriskDir"/sip.conf "$tempBackupDir"/sip.conf
cp "$asteriskDir"/iax.conf "$tempBackupDir"/iax.conf
cp "$asteriskDir"/voicemail.conf "$tempBackupDir"/voicemail.conf
cp "$asteriskDir"/extensions.conf "$tempBackupDir"/extensions.conf

echo -ne "Sauvegarde des fichiers de configuration dans $tempBackupDir ... : ""$VERT""fait.""$NORMAL""\r"
sleep 2
echo ""

echo -ne "Desinstallation d'Asterisk ... :\r"
apt-get -q=3 remove --purge asterisk -y
echo -ne "Desinstallation d'Asterisk ... : ""$VERT""fait.""$NORMAL""\r"
sleep 2

read -p "Desirez-vous recreer les fichiers de configuration d'Asterisk ? ([O]ui ou [N]on) : " -n1 newInstall
while [ "$newInstall" != "n" ] && [ "$newInstall" != "N" ] && [ "$newInstall" != "o" ] && [ "$newInstall" != "O" ];
	do
	echo "Choix invalide! Veuillez recommencer."
	read -p "Desirez-vous recreer les fichiers de configuration d'Asterisk ? ([O]ui ou [N]on) : " -n1 newInstall
	done

echo ""

if [ "$newInstall" == "O" ] || [ "$newInstall" == "o" ] 
	then
		./installAsterisk.sh
		
	else
		#Réinstallation Asterisk
		echo -ne "Reinstallation d'Asterisk ... :\r"
		apt-get -q=3 install asterisk -y
		echo -ne "Reinstallation d'Asterisk ... : ""$VERT""fait.""$NORMAL""\r"
		sleep 2
		echo ""

		echo -ne "Restauration des fichiers de configuration ... :"
		cp "$tempBackupDir"/sip.conf "$asteriskDir"/sip.conf
		cp "$tempBackupDir"/iax.conf "$asteriskDir"/iax.conf
		cp "$tempBackupDir"/voicemail.conf "$asteriskDir"/voicemail.conf
		cp "$tempBackupDir"/extensions.conf "$asteriskDir"/extensions.conf
		echo -ne "Restauration des fichiers de configuration ... : ""$VERT""fait.""$NORMAL"""
		sleep 2
		echo ""

fi

echo -ne "Copie des fichiers de sauvegarde dans $backupDir ... :\r"

if [ ! -d "$backupDir" ]
then 
	mkdir "$backupDir"
fi

cp "$tempBackupDir"/sip.conf "$backupDir"/sip.conf
cp "$tempBackupDir"/iax.conf "$backupDir"/iax.conf
cp "$tempBackupDir"/voicemail.conf "$backupDir"/voicemail.conf
cp "$tempBackupDir"/extensions.conf "$backupDir"/extensions.conf
echo -ne "Copie des fichiers de sauvegarde dans $backupDir ... : ""$VERT""fait.""$NORMAL""\r"
echo ""

echo -ne "Suppression des fichiers temporaires ... :\r"
rm "$tempBackupDir"/sip.conf
rm "$tempBackupDir"/iax.conf
rm "$tempBackupDir"/voicemail.conf
rm "$tempBackupDir"/extensions.conf
rmdir "$tempBackupDir"
echo -ne "Suppression des fichiers temporaires ... : ""$VERT""fait.""$NORMAL""\r"
echo ""

echo -ne "Enregistrement des données au sein d'Asterisk ... :\r"
asterisk -rx "reload"
echo -ne "Enregistrement des données au sein d'Asterisk ... : ""$VERT""fait.""$NORMAL""\r"
echo ""

read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1

