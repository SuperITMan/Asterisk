#!/bin/bash
# Script permettant la configuration du fichier iax.conf
# 

#apt-get update -q && apt-get upgrade -y && 
apt-get install curl -y

mv /etc/asterisk/sip.conf /etc/asterisk/sip.conf.old

isNat="yyy"
while [ $isNat != "n" ] && [ $isNat != "N" ] && [ $isNat != "o" ] && [ $isNat != "O" ];
do
echo -n "Le serveur Asterisk se trouve-t-il derrière un NAT ? ([O]ui ou [Non]) : "
read isNat
done

if [ $isNat == "O" ] || [ $isNat == "o" ]; then $isNat="yes"
else $isNat = "no"
fi

#result = ""
#while [ $result -ne 0 ]
#do
#echo -n "Veuillez : "
#read externip
#ping -q -c5 $externIp > /dev/null
#$result = $?
#done

externip = curl ident.me

touch /etc/asterisk/sip.conf

#Profil "general"
echo "[general]\ndefaultexpirey=1800			;Default duration (in seconds) of incoming/outgoing registration.\nqualify=yes			; Check if client is reachable. If yes, the checks occur every 60 seconds.\ndtmfmode=RFC2833			; specifies a different RTP packet format for DTMF Digits, to reduce transmitted data.\ndisallow=all			; disallows all codecs, required before specifying allowed codecs.\nallow=gsm			; Allow GSM codec.\nallow=ulaw			; Allow G711 codec.\nnat="$isNat"			; There is a NAT between Asterisk Server & Client.\ncanreinvite=no			; stops the sending of the (re)INVITEs once the call is established.\nexternip="$externIp"			; External IP of Server (if Public IP is static).\nbindport="$bindport"			; UDP Port to bind to (listen on).\ncontext=incoming			; Context for default calls.\n\n"  > /etc/asterisk/sip.conf

#Infos sur les différents éléments
echo ";--\ntype : friend (User can make & receive phone calls)\ncallerid, fullname : Self-explained\nusername, secret : Login credentials\nhasvoicemail, vmsecret : Has voicemail box, voicemail password\ncontext : dialplan for registered user\nlanguage : language of Asterisk default sounds\n--;\n\n" > /etc/asterisk/sip.conf

#Profil "coms"
echo "[coms](general)\ntype=friend\nhasvoicemail=yes\nvmsecret=1234\nqualify=yes\nhost=dynamic\ncontext=coms\nlanguage=fr\n" > /etc/asterisk/sip.conf

#Profil "insts"
echo "[insts](general)\ntype=friend\nhasvoicemail=yes\nvmsecret=1234\nqualify=yes\nhost=dynamic\ncontext=insts\nlanguage=fr\n" > /etc/asterisk/sip.conf

#Profil "suptechs"
echo "[suptechs](general)\ntype=friend\nhasvoicemail=yes\nvmsecret=1234\nqualify=yes\nhost=dynamic\ncontext=supptechs\nlanguage=fr\n" > /etc/asterisk/sip.conf

#Config 3 commerciaux par défaut
echo "[com1](coms)\nusername=com1\ncallerid=""Commercial 1"" <401>\nfullname=""Commercial 1""\nsecret=com1" > /etc/asterisk/sip.conf
echo "[com2](coms)\nusername=com2\ncallerid=""Commercial 2"" <402>\nfullname=""Commercial 2""\nsecret=com2" > /etc/asterisk/sip.conf
echo "[com3](coms)\nusername=com3\ncallerid=""Commercial 3"" <403>\nfullname=""Commercial 3""\nsecret=com3" > /etc/asterisk/sip.conf

#Config 3 installateurs par défaut
echo "[inst1](insts)\nusername=inst1\ncallerid=""Installateur 1"" <501>\nfullname=""Installateur 1""\nsecret=inst1" > /etc/asterisk/sip.conf
echo "[inst2](insts)\nusername=inst2\ncallerid=""Installateur 2"" <502>\nfullname=""Installateur 2""\nsecret=inst2" > /etc/asterisk/sip.conf
echo "[inst3](insts)\nusername=inst3\ncallerid=""Installateur 3"" <503>\nfullname=""Installateur 3""\nsecret=inst3" > /etc/asterisk/sip.conf

#Config 1 support technique par défaut
echo "[suptech1](suptechs)\nusername=suptech1\ncallerid=""Supp Tech"" <31>\nfullname=""Support Technique""\nsecret=suptech1" > /etc/asterisk/sip.conf

