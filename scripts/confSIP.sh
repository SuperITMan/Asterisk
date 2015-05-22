#!/bin/bash
# Script permettant la configuration du fichier iax.conf
# 

apt-get -q=3 install curl

sipDir="/etc/asterisk/sip.conf"

if [ -f "$sipDir" ]; then
mv "$sipDir" "$sipDir".old
fi

read -p "Le serveur Asterisk se trouve-t-il derriere un NAT ? ([O]ui ou [Non]) : " -n1 isNat
while [ $isNat != "n" ] && [ $isNat != "N" ] && [ $isNat != "o" ] && [ $isNat != "O" ];
do
echo "Erreur ! Veuillez répondre [O]ui ou [N]on"
read -p "Le serveur Asterisk se trouve-t-il derriere un NAT ? ([O]ui ou [N]on) : " -n1 isNat
done

echo ""

if [ $isNat == "O" ] || [ $isNat == "o" ] 
then 
isNat="yes"
else 
isNat="no"
fi

curl -s ident.me > /dev/null
externIp=$?
bindport="5060"

touch "$sipDir"

#Profil "general"
printf "[general]\ndefaultexpirey=1800		;Default duration (in seconds) of incoming/outgoing registration.\nqualify=yes			; Check if client is reachable. If yes, the checks occur every 60 seconds.\ndtmfmode=RFC2833		; specifies a different RTP packet format for DTMF Digits, to reduce transmitted data.\ndisallow=all			; disallows all codecs, required before specifying allowed codecs.\nallow=gsm			; Allow GSM codec.\nallow=ulaw			; Allow G711 codec.\nnat="$isNat"				; There is a NAT between Asterisk Server & Client.\ncanreinvite=no			; stops the sending of the (re)INVITEs once the call is established.\nexternip="$externIp"			; External IP of Server (if Public IP is static).\nbindport="$bindport"			; UDP Port to bind to (listen on).\ncontext=incoming		; Context for default calls.\n\n"  >> "$sipDir"

#Infos sur les différents éléments
printf ";--\ntype : friend (User can make & receive phone calls)\ncallerid, fullname : Self-explained\nusername, secret : Login credentials\nhasvoicemail, vmsecret : Has voicemail box, voicemail password\ncontext : dialplan for registered user\nlanguage : language of Asterisk default sounds\n--;\n\n" >> "$sipDir"

#Profil "coms"
printf "[coms](general)\ntype=friend\nhasvoicemail=yes\nvmsecret=1234\nqualify=yes\nhost=dynamic\ncontext=coms\nlanguage=fr\n\n" >> "$sipDir"

#Profil "insts"
printf "[insts](general)\ntype=friend\nhasvoicemail=yes\nvmsecret=1234\nqualify=yes\nhost=dynamic\ncontext=insts\nlanguage=fr\n\n" >> "$sipDir"

#Profil "suptechs"
printf "[suptechs](general)\ntype=friend\nhasvoicemail=yes\nvmsecret=1234\nqualify=yes\nhost=dynamic\ncontext=supptechs\nlanguage=fr\n\n" >> "$sipDir"

#Fin des profil
printf "\n-----------------\n\n" >> "$sipDir"

#Config du directeur
printf "[directeur](general)\ntype=friend\nhasvoicemail=yes\nvmsecret=1234\nqualify=yes\nhost=dynamic\ncontext=directeur\nlanguage=fr\nusername=directeur\ncallerid=""Directeur"" <101>\nfullname=""Directeur""\nsecret=directeur)\n\n" >> "$sipDir"

#Config de la secrétaire
printf "[secretaire](general)\ntype=friend\nhasvoicemail=yes\nvmsecret=1234\nqualify=yes\nhost=dynamic\ncontext=secretaire\nlanguage=fr\nusername=secretaire\ncallerid=""Secretaire"" <101>\nfullname=""Secretaire""\nsecret=secretaire)\n\n" >> "$sipDir"

#Config 3 commerciaux par défaut
printf "[com1](coms)\nusername=com1\ncallerid=""Commercial 1"" <401>\nfullname=""Commercial 1""\nsecret=com1\n\n" >> "$sipDir"
printf "[com2](coms)\nusername=com2\ncallerid=""Commercial 2"" <402>\nfullname=""Commercial 2""\nsecret=com2\n\n" >> "$sipDir"
printf "[com3](coms)\nusername=com3\ncallerid=""Commercial 3"" <403>\nfullname=""Commercial 3""\nsecret=com3\n\n" >> "$sipDir"

#Config 3 installateurs par défaut
printf "[inst1](insts)\nusername=inst1\ncallerid=""Installateur 1"" <501>\nfullname=""Installateur 1""\nsecret=inst1\n\n" >> "$sipDir"
printf "[inst2](insts)\nusername=inst2\ncallerid=""Installateur 2"" <502>\nfullname=""Installateur 2""\nsecret=inst2\n\n" >> "$sipDir"
printf "[inst3](insts)\nusername=inst3\ncallerid=""Installateur 3"" <503>\nfullname=""Installateur 3""\nsecret=inst3\n\n" >> "$sipDir"

#Config 1 support technique par défaut
printf "[suptech1](suptechs)\nusername=suptech1\ncallerid=""Supp Tech"" <301>\nfullname=""Support Technique""\nsecret=suptech1\n\n" >> "$sipDir"

