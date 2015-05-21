#!/bin/bash
#Script permettant la réinstallation d'Asterisk

asteriskDir="/etc/asterisk"
backupDir="/etc/asterisk/backupConf"
tempBackupDir="/tmp/backupAsterisk"

/etc/init.d/asterisk stop
sleep 2

#Sauvegarde des fichiers de confIax
echo "Sauvegarde des fichiers de configuration dans $tempBackupDir"
sleep 2
mkdir "$tempBackupDir"

cp "$asteriskDir"/sip.conf "$tempBackupDir"/sip.conf
cp "$asteriskDir"/iax.conf "$tempBackupDir"/iax.conf
cp "$asteriskDir"/voicemail.conf "$tempBackupDir"/voicemail.conf
cp "$asteriskDir"/extensions.conf "$tempBackupDir"/extensions.conf

echo "Sauvegarde des fichiers de configuration dans $tempBackupDir : fait!"
echo "Desinstallation d'Asterisk"
apt-get -q=3 remove --purge asterisk -y
echo "Desinstallation d'Asterisk : fait!"
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
		echo "Reinstallation d'Asterisk"
		apt-get -q=3 install asterisk -y
		echo "Reinstallation d'Asterisk : fait!"
		sleep 3

		echo "Restauration des fichiers de configuration"
		cp "$tempBackupDir"/sip.conf "$asteriskDir"/sip.conf
		cp "$tempBackupDir"/iax.conf "$asteriskDir"/iax.conf
		cp "$tempBackupDir"/voicemail.conf "$asteriskDir"/voicemail.conf
		cp "$tempBackupDir"/extensions.conf "$asteriskDir"/extensions.conf
		echo "Restauration des fichiers de configuration : fait!"

fi

echo "Copie des fichiers de sauvegarde dans $backupDir"

if [ -d "$backupDir" ]
then 
	mkdir "$backupDir"
fi

cp "$tempBackupDir"/sip.conf "$backupDir"/sip.conf
cp "$tempBackupDir"/iax.conf "$backupDir"/iax.conf
cp "$tempBackupDir"/voicemail.conf "$backupDir"/voicemail.conf
cp "$tempBackupDir"/extensions.conf "$backupDir"/extensions.conf
echo "Copie des fichiers de sauvegarde dans " "$backupDir" " : fait!"

echo "Suppression des fichiers temporaires"
rm "$tempBackupDir"/sip.conf
rm "$tempBackupDir"/iax.conf
rm "$tempBackupDir"/voicemail.conf
rm "$tempBackupDir"/extensions.conf
echo "Suppression des fichiers temporaires : fait!"

read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1

