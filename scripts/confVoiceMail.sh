#!/bin/bash
# Script permettant la configuration du voicemail sur Asterisk
# 

voicemailDir="/etc/asterisk/voicemail.conf"

if [ -f "$voicemailDir" ]; then
mv "$voicemailDir" "$voicemailDir".old
fi

touch "$voicemailDir"

printf "[general]\nformat=wav49|gsm|wav\nmaxsilence=10	; Max Silence time before ending message\nsilencethreshold=128\nmaxlogins=3\nsendvoicemail=yes\n\n" >> "$voicemailDir"
printf "[site2]\n; Voicemail boxes of respective employees\n101 => 1234,directeur\n201 => 1234,secretaire\n301 => 1234,suptech\n401 => 1234,com1\n402 => 1234,com2\n403 => 1234,com3\n501 => 1234,inst1\n502 => 1234,inst2\n503 => 1234,inst3\n\n" >> "$voicemailDir"
