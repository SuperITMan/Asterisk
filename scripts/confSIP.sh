#!/bin/sh
# Script permettant la configuration du fichier iax.conf
# 

apt-get update -q && apt-get upgrade -y && apt-get install curl -y

mv /etc/asterisk/sip.conf /etc/asterisk/sip.conf.old

isNat ="yyy"
while [ $isNat != "n" && $isNat != "N" && $isNat != "o" && $isNat != "O" ]
do
echo -n "Le serveur Asterisk se trouve-t-il derrière un NAT ? ([O]ui ou [Non]) : "
read isNat
done

if[ $isNat == "O" || $isNat == "o" ]; then $isNat="yes"
else $isNat = "no"
fi

;result = ""
;while [ $result -ne 0 ]
;do
;echo -n "Veuillez : "
;read externip
;ping -q -c5 $externIp > /dev/null
;$result = $?
;done

externip = curl ident.me

touch /etc/asterisk/sip.conf

echo "[general]\ndefaultexpirey=1800			;Default duration (in seconds) of incoming/outgoing registration.\nqualify=yes			; Check if client is reachable. If yes, the checks occur every 60 seconds.\ndtmfmode=RFC2833			; specifies a different RTP packet format for DTMF Digits, to reduce transmitted data.\ndisallow=all			; disallows all codecs, required before specifying allowed codecs.\nallow=gsm			; Allow GSM codec.\nallow=ulaw			; Allow G711 codec.\nnat="$isNat"			; There is a NAT between Asterisk Server & Client.\ncanreinvite=no			; stops the sending of the (re)INVITEs once the call is established.\nexternip="$externIp"			; External IP of Server (if Public IP is static).\nbindport="$bindport"			; UDP Port to bind to (listen on).\ncontext=incoming			; Context for default calls."  > /etc/asterisk/sip.conf



echo "[trunk-remmoteAsterisk]\ntype=peer\nusername=remoteuser\nsecret=123456\nhost="$hostAddress"\ntrunk=yes\nqualify=yes\n\n[remoteuser]\ntype=user\nsecret=123456\ncontext=default" > /etc/asterisk/iax.conf