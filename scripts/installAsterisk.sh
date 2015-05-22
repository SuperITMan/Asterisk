#!/bin/bash
#Script permettant l'installation d'Asterisk
VERT="\\033[1;32m"
ROUGE="\\033[1;31m"
NORMAL="\\033[0;39m"

echo -ne "Mise a jour du système ... :\r"
apt-get -q=3 update && apt-get -q=3 upgrade
echo -ne "Mise a jour du systeme : ""$VERT""fait!""$NORMAL""\r"

echo ""

echo -ne "Installation d'Asterisk ... :\r"
apt-get -q=3 install asterisk
echo -ne "Installation d'Asterisk ... : fait!\r"

echo ""

echo -ne "Configuration de l'IAX sur la machine hote ... :\r"
./confIax.sh
echo -ne "Configuration de l'IAX sur la machine hote ... : fait!\r"
sleep 2

echo ""

echo -ne "Configuration du SIP ... :\r"
./confSIP.sh
echo -ne "Configuration du SIP ... : fait\r"
sleep 2

echo ""

echo -ne "Configuration du DialPlan ... :\r"
./confExtensions.sh
echo -ne "Configuration du DialPlan ... : fait!\r"
sleep 2

echo ""

echo -ne "Configuration du VoiceMail\r"
./confVoiceMail.sh
echo -ne "Configuration du VoiceMail : fait!\r"
sleep 2

#Nettoyage après installations
echo "Nettoyage de fin d'installation"
apt-get -q=3 autoclean
apt-get -q=3 autoremove
echo "Installation terminee!"
read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
echo ""
