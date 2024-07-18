#!/bin/bash

# INSTALAR E ATUALIZAR DEPENDÊNCIAS
sudo apt update
sudo apt install -y apache2 php libapache2-mod-php php-mysql mysql-server unzip curl php-cli php-mbstring iputils-ping nano

#FIXAR IP ESTÁTICO NO SERVIDOR
sudo tee /etc/netplan/01-netcfg.yaml << 'EOF'
network:
    version: 2
    renderer: networkd
    ethernets:
        enp0s3:
        dhcp4: no
        addresses:
            - 192.168.1.18/24
        gateway4: 192.168.1.254
        nameservers:
        addresses:
            -8.8.8.8 
            -8.8.4.4
EOF
sudo netplan apply
sudo systemctl restart networking

# CRIAR ESTRUTURA DE DIRETÓRIO
sudo mkdir -p /var/www/html/rat

#INSTALAR O FPDF
cd /var/www/html/rat
sudo curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo tee /var/www/html/rat/composer.json << 'EOF'
{
    "require": {
        "setasign/fpdf": "^1.8"
    }
}
EOF
sudo composer install
cd ~/

#CONFIGURAR PERMISSÕES
sudo chmod -R 775 /var/www/html/

#CONFIGURAR MYSQL
sudo mysql -e "CREATE DATABASE rat_db;"
sudo mysql -e "CREATE USER 'alessandro'@'localhost' IDENTIFIED BY 'ale@2024';"
sudo mysql -e "GRANT ALL PRIVILEGES ON rat_db.* TO 'alessandro'@'locahost';"
sudo mysql -e "FLUSH PRIVILEGES;"

#CRIAR TABELAS NO MYSQL
sudo mysql -u alessandro -p'ale@2024' rat_db << 'EOF'
CREATE TABLE tecnicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    email VARCHAR(50),
    celular VARCHAR(20)
);

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    email VARCHAR(50),
    telefone VARCHAR(20)
);

CREATE TABLE atendimentos (
    id INT AUTO_INCREMENT PRIMARY KEY
    tecnicos_id INT,
    clientes_id INT,
    data DATETIME,
    descricao TEXT,
    FOREIGN KEY (tecnicos_id) REFERENCES tecnicos(id),
    FOREIGN KEY (clientes_id) REFERENCES clientes(id)
);
EOF

#CONFIGURAR APACHE
sudo sh -c 'echo "<VirtualHost *:80>
    DocumentRoot /var/www/html/rat
    <Directory /var/www/html/rat>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>" > /etc/apache2/sites-available/rat.conf'

sudo a2ensite rat.conf
sudo a2dissite 000-default.conf

#COPIAR ARQUIVOS PARA /var/www/html/rat
cd /RAT
sudo cp -r *.* /var/www/html/rat/

#DAR PERMISSÔES AS PASTAS
sudo chown -R www-data:www-data /var/www/html/rat
sudo chmod -R 775 /var/www/html/rat
sudo chmod -R 775 /var/www/html/rat/vendor
sudo chown -R www-data:www-data /var/www/html/rat/vendor

#RESTART DO APACHE
sudo systemctl restart apache2

echo "INSTALAÇÃO E CONFIGURAÇÃO CONCLUÍDAS COM SUCESSO."