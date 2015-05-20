#!/bin/sh
# Script permettant l'installation d'Asterisk sur un serveur Debian nu
# 

apt-get update -q && apt-get upgrade -y
apt-get install asterisk -y
apt-get install curl -y