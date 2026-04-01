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


echo "=== Téléchargement de WordPress ==="
cd /tmp
rm -rf wordpress latest.tar.gz
wget -O latest.tar.gz https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz

echo "=== Copie des fichiers WordPress ==="
sudo cp -r wordpress/* "$SITE_DIR"

echo "=== Création de la base de données ==="
sudo mysql <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "=== Configuration de wp-config.php ==="
cd "$SITE_DIR"
sudo cp wp-config-sample.php wp-config.php

sudo sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sudo sed -i "s/username_here/$DB_USER/" wp-config.php
sudo sed -i "s/password_here/$DB_PASS/" wp-config.php

echo "=== Permissions ==="
sudo chown -R www-data:www-data "$SITE_DIR"
sudo find "$SITE_DIR" -type d -exec chmod 755 {} \;
sudo find "$SITE_DIR" -type f -exec chmod 644 {} \;

echo "=== Activation de mod_rewrite ==="
sudo a2enmod rewrite
sudo systemctl restart apache2

echo "=== Installation terminée ==="
IP_VM=$(hostname -I | awk '{print $2}')
echo "Ouvre maintenant : http://$IP_VM/"
