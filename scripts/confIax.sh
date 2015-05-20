#!/bin/sh
#Script permettant la configuration du fichier iax.conf


mv /etc/asterisk/iax.conf /etc/asterisk/iax.conf.old
echo -n "Host de la machine distante sur laquelle se connecter : "
read hostAddress

touch /etc/asterisk/iax.conf

echo "[trunk-remmoteAsterisk]\ntype=peer\nusername=remoteuser\nsecret=123456\nhost="$hostAddress"\ntrunk=yes\nqualify=yes\n\n" > /etc/asterisk/iax.conf
echo "[remoteuser]\ntype=user\nsecret=123456\ncontext=default" > /etc/asterisk/iax.conf