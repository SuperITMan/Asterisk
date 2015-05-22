#!/bin/bash
#Script permettant l'installation d'Asterisk
VERT="\\033[1;32m"
ROUGE="\\033[1;31m"
NORMAL="\\033[0;39m"

echo -ne "Mise a jour du système ... :\r"
apt-get -q=3 update && apt-get -q=3 upgrade
echo -ne "Mise a jour du systeme ... : ""$VERT""fait.""$NORMAL""\r"

echo ""

echo -ne "Installation d'Asterisk ... :\r"
apt-get -q=3 install asterisk
echo -ne "Installation d'Asterisk ... : ""$VERT""fait.""$NORMAL""\r"

echo ""

echo -ne "Configuration de l'IAX sur la machine hote ... :\r"
./confIax.sh
echo -ne "Configuration de l'IAX sur la machine hote ... : ""$VERT""fait.""$NORMAL""\r"
sleep 2

echo ""

echo -ne "Configuration du SIP ... :\r"
./confSIP.sh
echo -ne "Configuration du SIP ... : ""$VERT""fait.""$NORMAL""\r"
sleep 2

echo ""

echo -ne "Configuration du DialPlan ... :\r"
./confExtensions.sh
echo -ne "Configuration du DialPlan ... : ""$VERT""fait.""$NORMAL""\r"
sleep 2

echo ""

echo -ne "Configuration du VoiceMail ... :\r"
./confVoiceMail.sh
echo -ne "Configuration du VoiceMail ... : ""$VERT""fait.""$NORMAL""\r"
sleep 2

echo ""

#Nettoyage après installations
echo -ne "Nettoyage de fin d'installation ... :\r"
apt-get -q=3 autoclean
apt-get -q=3 autoremove
echo -ne "Nettoyage de fin d'installation ... : ""$VERT""fait.""$NORMAL""\r"
echo "Installation terminee!"
read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
echo ""
