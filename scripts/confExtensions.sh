#!/bin/bash
# Script permettant la configuration du dialplan d'Asterisk
# 

VERT="\\033[1;32m"
ROUGE="\\033[1;31m"
NORMAL="\\033[0;39m"

extensionsDir="/etc/asterisk/extensions.conf"

if [ -f "$extensionsDir" ]; then
mv "$extensionsDir" "$extensionsDir".old
fi

echo -n "Veuillez entrer l'host de la machine distante sur laquelle se connecter : "
read ipAddress

echo -ne "Verification de la connexion a l'host donne ... :\r"
ping -q -c2 $ipAddress
pingTest=$?

while [ $pingTest -ne 0 ];
do
	echo -ne "Verification de l'host donne ... : ""$ROUGE""erreur.""$NORMAL""\r"
	echo "L'adresse indiquee est erronee."
	echo -n "Veuillez entrer l'host de la machine distante sur laquelle se connecter : "
	read ipAddress
	ping -q -c2 $ipAddress
	pingTest=$?
done

echo -ne "Verification de l'host donne ... : ""$VERT""fait.""$NORMAL""\r"

touch "$extensionsDir"

printf "[general]\nstatic=yes\nwriteprotect=no\nclearglobalvars=no\n\n" >> "$extensionsDir"
printf "[globals]\n;Defines registered users as shortened variables\nDIRECTEUR=SIP/directeur\nSECRETAIRE=SIP/secretaire\nSUPTECH=SIP/suptech\nCOM1=SIP/com1\nCOM2=SIP/com2\nCOM3=SIP/com3\nINST1=SIP/inst1\nINST2=SIP/inst2\nINST3=SIP/inst3\n\n" >> "$extensionsDir"
printf "[incoming]\n;When no extensions entered into call, starts here\n;If not between 9h & 19h Monday-Friday or weekend, direct to voicemail of secretaire\n;Menu prompt describes choices to callers\nexten => s,1,Answer()\nsame  => n,GotoIfTime(19:00-9:00,mon-fri,*,*?closed,s,1)\nsame  => n,GotoIfTime(*,sat&sun,*,*?closed,s,1)\nsame  => n,Background(main-menu)\nsame  => n,WaitExten(30)\n;if 1 dialed at prompt, call Secretaire\nexten => 1,1,Dial(${SECRETAIRE},15)\nsame => n,VoiceMail(201@site2)\nsame => n,Hangup()\n;if 3 dialed at prompt, call Support Technique\nexten => 3,1,Dial(${SUPTECH},15)\nsame => n,VoiceMail(301@site2)\nsame => n,Hangup()\n;if 4 dialed, call a random Commerciaux\nexten => 4,1,Goto(randomComs,04,1)\n;if invalid choice, return to start\nexten => i,1,Playback(pbx-invalid)\nsame  => n,Goto(incoming,s,1)\n;else, hangup\nexten => t,1,Playback(vm-goodbye)\nsame  => n,Hangup()\n\n" >> "$extensionsDir"

printf "[outboundGen]\n;Press 700, automatic towards dialers voicemail box. Enter password\nexten => 700,1,VoiceMailMain(\${CALLERID(num)}@site2)\n;To access outbound calling, press 9 followed by phone number you wish to call\nexten => _9.,1,Dial(\${OUTBOUND}/\${EXTEN:1})\n\n" >> "$extensionsDir"

printf "[outboundInternal]\n	;Dial 8 followed by extension of other site to contact other site extensions\nexten => _8XXX,1,Dial(IAX2/site2:site123@"$ipAddress"/${EXTEN:1})\n\n" >> "$extensionsDir"

printf "[outboundComs]\n;Dial 8 followed by extension of other site to contact Commerciaux & Secretaire\nexten => _82X1,1,Dial(IAX2/site2:site123@"$ipAddress"/${EXTEN:1})\nexten => _84XX,1,Dial(IAX2/site2:site123@"$ipAddress"/${EXTEN:1})\n\n" >> "$extensionsDir"

printf "[callDirecteur]\n;Directeur\n;Dial 101 to call Directeur, if not available: Voicemail\nexten => 101,1,Dial(${DIRECTEUR}, 15)\nsame => n,Hangup()\n\n" >> "$extensionsDir"

printf "[callSecretaire]\n;Secrétaire\n;Dial 201 to call Secretaire, if not available: Voicemail\nexten => 201,1,Dial(${SECRETAIRE}, 15)\nsame => n,VoiceMail(201@site2)\nsame => n,Hangup()\n\n" >> "$extensionsDir"

printf "[callSupTech]\n;Support Technique\n;Dial 301 to call Support Technique, if not available: Voicemail\nexten => 301,1,Dial(${SUPTECH}, 15)\nsame => n,VoiceMail(301@site2)\nsame => n,Hangup()\n\n" >> "$extensionsDir"

printf "[callComs]\n;Commercial 1\n;Dial 401 to call Commercial 1, if not available: Voicemail\nexten => 401,1,Dial(${COM1}, 15)\nsame => n,VoiceMail(401@site2)\nsame => n,Hangup()\n;Commercial 2\n;Dial 402 to call Commercial 2, if not available: Voicemail\nexten => 402,1,Dial(${COM2}, 15)\nsame => n,VoiceMail(402@site2)\nsame => n,Hangup()\n;Commercial 3\n;Dial 403 to call Commercial 3, if not available: Voicemail\nexten => 403,1,Dial(${COM3}, 15)\nsame => n,VoiceMail(403@site2)\nsame => n,Hangup()\n\n" >> "$extensionsDir"

printf "[callInsts]\n;Installateur 1\n;Dial 501 to call Installer 1, if not available: Voicemail\nexten => 501,1,Dial(${INST1}, 15)\nsame => n,VoiceMail(501@site2)\nsame => n,Hangup()\n;Installateur 2\n;Dial 502 to call Installer 2, if not available: Voicemail\nexten => 502,1,Dial(${INST2}, 15)\nsame => n,VoiceMail(502@site2)\nsame => n,Hangup()\n;Installateur 3\n;Dial 503 to call Installer 3, if not available: Voicemail\nexten => 503,1,Dial(${INST3}, 15)\nsame => n,VoiceMail(503@site2)\nsame => n,Hangup()\n\n" >> "$extensionsDir"

printf "[randomComs]\nDial 04 for random commercial - Used by Directeur, Secretaire (from both sites) + Incoming\nexten => 04,1,Set(junky=\${RAND(401,403)})\nsame => n,Dial(SIP/com\${junky},15)\nsame => n,VoiceMail(com\${junky}@site2)\nsame => n, Hangup()\n\n" >> "$extensionsDir"

printf "[randomInsts]\nDial 05 for random installateur - Used by Directeur, Secretaire\nsame => n,Dial(SIP/inst${junky},15)\nsame => n,VoiceMail(inst${junky}@site2)\nsame => n, Hangup()\n\n" >> "$extensionsDir"

printf "[site2]\n; If caller from site 1, can reach Director, Secretary, specific Commercial, &/or random Commercial\ninclude => callDirecteur\ninclude => callSecretaire\ninclude => callComs\ninclude => randomComs\n\n" >> "$extensionsDir"

printf "[summary]\n;Includes all possibilities except Directeur or Secretaire\ninclude => site1\ninclude => outboundGen\ninclude => callSupTech\ninclude => callComs\ninclude => callInsts\ninclude => randomComs\ninclude => randomInsts\n\n" >> "$extensionsDir"

printf "[directeur]\n; If Directeur, can reach anyone on own site + Directeur,Secretaire,Commercials on other site + make outbound phone calls\ninclude => summary\ninclude => callSecretaire\n\n" >> "$extensionsDir"

printf "[secretaire]\n; If Secretaire, can reach anyone on own site + Directeur,Secretaire,Commercials on other site + make outbound phone calls\ninclude => summary\ninclude => callDirecteur\n\n" >> "$extensionsDir"

printf "[suppTech]\n; If Support Technique, can reach Secretaire, Commercials, Installateurs on own site + outbound phone calls\ninclude => outboundGen\ninclude => callSecretaire\ninclude => callComs\ninclude => callInsts\n\n" >> "$extensionsDir"

printf "[coms]\n; If Commercial, can reach Secretaire, other Commercials, Installateurs + Directeur,Secretaire,Commercials on other site + make outbound phone calls\ninclude => site1\ninclude => outboundGen\ninclude => outboundComs\ninclude => callSecretaire\ninclude => callComs\ninclude => callInsts\ninclude => callSupTech\n\n" >> "$extensionsDir"

printf "[insts]\n; If Installateur, can reach Secretaire, Commercials, other Installateurs and make outbound phone calls\ninclude => outboundGen\ninclude => callSecretaire\ninclude => callComs\ninclude => callInsts\ninclude => callSupTech\n\n" >> "$extensionsDir"

printf "[closed]\n;If closed, direct to secretaire voicemail\nexten => s,1,VoiceMail(201@site2)\n\n" >> "$extensionsDir"