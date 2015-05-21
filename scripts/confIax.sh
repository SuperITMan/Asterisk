#!/bin/bash
#Script permettant la configuration du fichier iax.conf


mv /etc/asterisk/iax.conf /etc/asterisk/iax.conf.old

echo -n "Veuillez entrer l'host de la machine distante sur laquelle se connecter : "
read hostAddress

echo "Vérification de l'host donné"
ping -q -c2 $hostAddress
pingTest=$?

while [ $pingTest -ne 0 ];
do
	echo "Vérification de l'host donné : erreur!"
	echo "L'adresse indiquée est erronée."
	echo -n "Veuillez entrer l'host de la machine distante sur laquelle se connecter : "
	read hostAddress
	ping -q -c2 $hostAddress
	pingTest=$?
done

echo "Vérification de l'host donné : fait!"

touch /etc/asterisk/iax.conf

printf "[trunk-remoteAsterisk]\ntype=peer\nusername=remoteuser\nsecret=123456\nhost="$hostAddress"\ntrunk=yes\nqualify=yes\n\n" >> /etc/asterisk/iax.conf
printf "[remoteuser]\ntype=user\nsecret=123456\ncontext=default" >> /etc/asterisk/iax.conf