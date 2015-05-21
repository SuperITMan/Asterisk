#!/bin/bash
#Script permettant l'installation d'Asterisk

echo "Mise a jour du système"
apt-get -q=3 update && apt-get -q=3 upgrade
echo "Mise a jour du système : fait!"
echo "Installation d'Asterisk"
apt-get -q=3 install asterisk
echo "Installation d'Asterisk : fait!"
echo "Configuration de l'IAX"
./confIax.sh
echo "Configuration de l'IAX : fait!"
sleep 2
echo "Configuration du SIP"
./confSIP.sh
echo "Configuration du SIP : fait!"
sleep 2

#Nettoyage après installations
echo "Nettoyage de fin d'installation"
apt-get -q=3 autoclean
apt-get -q=3 autoremove
echo "Installation terminee!"
read -p "Appuyez sur n'importe quelle touche pour continuer..." -n1
