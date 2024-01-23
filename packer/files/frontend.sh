#!/bin/bash

# Configuración para evitar mensajes interactivos de debconf
export DEBIAN_FRONTEND=noninteractive

# Instalar dependencias
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y nginx

# Mover el archivo de configuración de Nginx a su ubicación final
sudo mv -f /tmp/mean.conf /etc/nginx/conf.d/default.conf
sudo mv -f /tmp/nginx.conf /etc/nginx/nginx.conf

# Mover los archivos del frontend a la carpeta de Nginx
sudo mv -f /tmp/browser/* /usr/share/nginx/html/
sudo mv -f /tmp/assets /usr/share/nginx/html/assets

# Iniciar el proxy Nginx
sudo systemctl enable nginx
sudo systemctl start nginx
