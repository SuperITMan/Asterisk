#!/bin/bash
#Script permettant la configuration du fichier iax.conf

VERT="\\033[1;32m"
ROUGE="\\033[1;31m"
NORMAL="\\033[0;39m"

iaxDir="/etc/asterisk/iax.conf"

if [ -f "$iaxDir" ]; then
mv "$iaxDir" "$iaxDir".old
fi

echo -n "Veuillez entrer l'host de la machine distante sur laquelle se connecter : "
read hostAddress

echo -ne "Verification de la connexion a l'host donne ... :\r"
ping -q -c2 $hostAddress
pingTest=$?

while [ $pingTest -ne 0 ];
do
	echo -ne "Verification de l'host donne ... : ""$ROUGE""erreur.""$NORMAL""\r"
	echo "L'adresse indiquee est erronee."
	echo -n "Veuillez entrer l'host de la machine distante sur laquelle se connecter : "
	read hostAddress
	ping -q -c2 $hostAddress
	pingTest=$?
done

echo -ne "Verification de l'host donne ... : ""$VERT""fait.""$NORMAL""\r"
echo ""

touch "$iaxDir"

printf "[trunk-remoteAsterisk]\ntype=peer\nusername=remoteuser\nsecret=123456\nhost="$hostAddress"\ntrunk=yes\nqualify=yes\n\n" >> "$iaxDir"
printf "[remoteuser]\ntype=user\nsecret=123456\ncontext=default" >> "$iaxDir"