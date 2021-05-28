#!/usr/bin/bash

#Test si openjdk est installé
dpkg -l | grep openjdk-11-jdk
RETOUR_INSTALL_OPENJDK=$?
#Test presence du binaire gradle
RETOUR_BIN_GRADLE=gradle --version
RETOUR_GRADLE=$?
if [[ $RETOUR_INSTALL_OPENJDK = 0 ]] && [[ $RETOUR_GRADLE = 0 ]]; then
    echo "Serveur build déjà installé"
    exit 0
fi

sudo apt -y update

sudo apt -y install openjdk-11-jdk
sudo apt -y install unzip

#Download des sources
VERSION=7.0
cd /tmp
URLDL=https://services.gradle.org/distributions/gradle-${VERSION}-bin.zip
wget $URLDL
sleep 5s
if [[ ! -f /tmp/gradle-${VERSION}-bin.zip ]]; then
    echo "Problème de download $URLDL \n"
    exit 0
fi

#unzip
if [[ ! -d /opt/gradle ]]; then
    unzip -d /opt/gradle /tmp/gradle-${VERSION}-bin.zip
else
    echo "/opt/gradle déjà présent\n"
    exit 0
fi
# Faire pointer le lien vers la dernière version de gradle
ln -s /opt/gradle/gradle-${VERSION} /opt/gradle/latest

# Ajout de gradle au PATH pour la variable d'environnement
touch /etc/profile.d/gradle.sh
echo "export PATH=/opt/gradle/latest/bin:${PATH}" > /etc/profile.d/gradle.sh

chmod +x /etc/profile.d/gradle.sh
source /etc/profile.d/gradle.sh

## Ajout de python3:
sudo apt -y install python3 python3-pip

#positionnement de python3 et pip3 dans le profil
alias python='/usr/bin/python3' > ~/.bashrc
alias pip=pip3 > ~/.bashrc

#install utilitaire de test
sudo pip install pytest