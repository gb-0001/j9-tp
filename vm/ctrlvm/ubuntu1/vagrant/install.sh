#!/bin/bash

#mise en place du mot de passe pour vagrant
echo 'vagrant:vagrant' | sudo chpasswd

#Preparation pour l'echange de clé ssh et restart du service pour prise en compte essai la 1ere sinon la 2eme
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo service sshd restart