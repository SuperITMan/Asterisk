#!/bin/bash
# Script permettant la configuration du fichier iax.conf
# 

#apt-get update -q && apt-get upgrade -y && 
apt-get install curl -y

mv /etc/asterisk/sip.conf /etc/asterisk/sip.conf.old

isNat="yyy"
while [ $isNat != "n" ] && [ $isNat != "N" ] && [ $isNat != "o" ] && [ $isNat != "O" ];
do
read -p "Le serveur Asterisk se trouve-t-il derrière un NAT ? ([O]ui ou [Non]) : " -n1 isNat
#read isNat
done

if [ $isNat == "O" ] || [ $isNat == "o" ] 
then 
isNat="yes"
else 
isNat="no"
fi

curl ident.me
externIp=$?
bindport="3060"

touch /etc/asterisk/sip.conf

#Profil "general"
printf "[general]\ndefaultexpirey=1800			;Default duration (in seconds) of incoming/outgoing registration.\nqualify=yes			; Check if client is reachable. If yes, the checks occur every 60 seconds.\ndtmfmode=RFC2833			; specifies a different RTP packet format for DTMF Digits, to reduce transmitted data.\ndisallow=all			; disallows all codecs, required before specifying allowed codecs.\nallow=gsm			; Allow GSM codec.\nallow=ulaw			; Allow G711 codec.\nnat="$isNat"			; There is a NAT between Asterisk Server & Client.\ncanreinvite=no			; stops the sending of the (re)INVITEs once the call is established.\nexternip="$externIp"			; External IP of Server (if Public IP is static).\nbindport="$bindport"			; UDP Port to bind to (listen on).\ncontext=incoming			; Context for default calls.\n\n"  >> /etc/asterisk/sip.conf

#Infos sur les différents éléments
printf ";--\ntype : friend (User can make & receive phone calls)\ncallerid, fullname : Self-explained\nusername, secret : Login credentials\nhasvoicemail, vmsecret : Has voicemail box, voicemail password\ncontext : dialplan for registered user\nlanguage : language of Asterisk default sounds\n--;\n\n" >> /etc/asterisk/sip.conf

#Profil "coms"
printf "[coms](general)\ntype=friend\nhasvoicemail=yes\nvmsecret=1234\nqualify=yes\nhost=dynamic\ncontext=coms\nlanguage=fr\n" >> /etc/asterisk/sip.conf

#Profil "insts"
printf "[insts](general)\ntype=friend\nhasvoicemail=yes\nvmsecret=1234\nqualify=yes\nhost=dynamic\ncontext=insts\nlanguage=fr\n" >> /etc/asterisk/sip.conf

#Profil "suptechs"
printf "[suptechs](general)\ntype=friend\nhasvoicemail=yes\nvmsecret=1234\nqualify=yes\nhost=dynamic\ncontext=supptechs\nlanguage=fr\n\n" >> /etc/asterisk/sip.conf

#Config 3 commerciaux par défaut
printf "[com1](coms)\nusername=com1\ncallerid=""Commercial 1"" <401>\nfullname=""Commercial 1""\nsecret=com1\n" >> /etc/asterisk/sip.conf
printf "[com2](coms)\nusername=com2\ncallerid=""Commercial 2"" <402>\nfullname=""Commercial 2""\nsecret=com2\n" >> /etc/asterisk/sip.conf
printf "[com3](coms)\nusername=com3\ncallerid=""Commercial 3"" <403>\nfullname=""Commercial 3""\nsecret=com3\n" >> /etc/asterisk/sip.conf

#Config 3 installateurs par défaut
printf "[inst1](insts)\nusername=inst1\ncallerid=""Installateur 1"" <501>\nfullname=""Installateur 1""\nsecret=inst1\n" >> /etc/asterisk/sip.conf
printf "[inst2](insts)\nusername=inst2\ncallerid=""Installateur 2"" <502>\nfullname=""Installateur 2""\nsecret=inst2\n" >> /etc/asterisk/sip.conf
printf "[inst3](insts)\nusername=inst3\ncallerid=""Installateur 3"" <503>\nfullname=""Installateur 3""\nsecret=inst3\n" >> /etc/asterisk/sip.conf

#Config 1 support technique par défaut
printf "[suptech1](suptechs)\nusername=suptech1\ncallerid=""Supp Tech"" <301>\nfullname=""Support Technique""\nsecret=suptech1\n" >> /etc/asterisk/sip.conf

