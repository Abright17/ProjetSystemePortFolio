#!/bin/bash
set -e
echo "=== Mise à jour des paquets ==="
sudo apt update -y
echo "=== Installation Apache, MySQL, PHP ==="
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql wget tar curl


echo "=== Démarrage des services ==="
sudo systemctl enable apache2
sudo systemctl start apache2
sudo systemctl enable mysql
sudo systemctl start mysql

SITE_DIR="/var/www/html"
DB_NAME="wpdb"
DB_USER="wpuser"
DB_PASS="password123"

echo "=== Nettoyage du dossier web par défaut ==="
sudo rm -rf "${SITE_DIR:?}/"*
