#!/bin/bash
set -e
echo "=== Mise à jour des paquets ==="
sudo apt update -y
echo "=== Installation Apache, MySQL, PHP ==="
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql wget tar curl

