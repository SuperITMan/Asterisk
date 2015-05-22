#!/bin/bash
#Script permettant la configuration du fichier iax.conf

iaxDir="/etc/asterisk/iax.conf"

if [ -f "$iaxDir" ]; then
mv "$iaxDir" "$iaxDir".old
fi

echo -n "Veuillez entrer l'host de la machine distante sur laquelle se connecter : "
read hostAddress

echo "Verification de l'host donne"
ping -q -c2 $hostAddress
pingTest=$?

while [ $pingTest -ne 0 ];
do
	echo "Verification de l'host donne : erreur!"
	echo "L'adresse indiquee est erronee."
	echo -n "Veuillez entrer l'host de la machine distante sur laquelle se connecter : "
	read hostAddress
	ping -q -c2 $hostAddress
	pingTest=$?
done

echo "Verification de l'host donne : fait!"

touch "$iaxDir"

printf "[trunk-remoteAsterisk]\ntype=peer\nusername=remoteuser\nsecret=123456\nhost="$hostAddress"\ntrunk=yes\nqualify=yes\n\n" >> "$iaxDir"
printf "[remoteuser]\ntype=user\nsecret=123456\ncontext=default" >> "$iaxDir"