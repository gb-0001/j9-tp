#!/bin/bash
#script d'installation du serveur d'integration

dpkg -l | grep jenkins
if [ $? = 0 ]; then
    echo "Serveur intégration déjà installé"
    exit 0
fi


sudo mkdir /userjob

#mise en place du mot de passe pour vagrant
echo 'vagrant:vagrant' | sudo chpasswd

## Install des pré-requis Java
sudo apt -y update
sudo apt -y install gnupg
sudo apt -y install openjdk-11-jdk
## Install de la version stable de Jenkins et ses prérequis en suivant la documentation officielle : https://www.jenkins.io/doc/book/installing/linux
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'

#install jenkins
sudo apt -y update
sudo apt -y install jenkins

## Démarre le service Jenkins
sudo service start jenkins

#Test si le user nexus existe
RETOUR_USER_USERJOB=sudo cat /etc/passwd | grep -i userjob
#creation du user nexus et positionnement dans le sudoers
if [[ $RETOUR_USER_USERJOB != 0 ]]; then
    sudo useradd -m userjob -d /userjob
    echo 'userjob ALL=(ALL:ALL) /usr/bin/apt' | sudo EDITOR='tee -a' visudo
fi

#install git, docker ansible sshpass
sudo apt -y install python3 python3-pip git docker docker-py ansible sshpass

sudo apt -y install git

sudo apt -y install ansible sshpass

sudo apt -y install docker
sudo pip3 install docker

#pour le fonctionnement de sshpass avec ansible
sudo sed -i 's/#host_key_checking = False/host_key_checking = False/g' /etc/ansible/ansible.cfg

#Autorisation de l'acces jenkins
ufw allow 8080/tcp

#Affiche le password
echo 'Mot de passe dans 1min en cours de generation PATIENTEZ SVP...:\n'
sleep 1m
sudo cat /var/lib/jenkins/secrets/initialAdminPassword