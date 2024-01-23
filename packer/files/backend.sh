#!/bin/bash

# Crear el directorio de trabajo
sudo mkdir /app

cd /app || exit 1

# Instalar dependencias
#sudo yum update -y
sudo yum install -y nodejs npm

# Configuración del repositorio de MongoDB
sudo tee /etc/yum.repos.d/mongodb-org-7.0.repo <<EOL
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc
EOL

# Instalamos MongoDB
sudo yum install -y mongodb-org

# Permitir el tráfico en el puerto 3000 (NodeJS)
#sudo firewall-cmd --add-port=3000/tcp --permanent
#sudo firewall-cmd --reload

# Desactivar SELinux temporalmente
sudo setenforce 0

# La aplicación del Backend será lanzada con PM2,
# así que hay que instalarlo de forma global
sudo npm i -g pm2

# Movemos los archivos de la carpeta temporal a la carpeta /app
sudo mv -f /tmp/backend/* /app
sudo npm install

# Iniciamos la base de datos
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod

# Iniciar la aplicación como demonio y guardar el estado
sudo "$(which pm2)" start /app/server.js
sudo "$(which pm2)" save
sudo "$(which pm2)" startup
