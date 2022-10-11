#!/bin/bash

sudo apt-get update
sudo apt-get upgrade

sudo rm -r /etc/dhcpcd.conf

echo -e "
interface wlan0
static ip_address=192.168.88.253
static routers=192.168.88.1
static domain_name_servers=192.168.88.1 8.8.8.8

interface eth0
static ip_address=192.168.2.3
static routers=192.168.2.1
static domain_name_servers=192.168.2.1

" >>  /etc/dhcpcd.conf

sudo apt install nginx -y
sudo service nginx start


sudo wget -O - https://raw.githubusercontent.com/pjgpetecodes/dotnet5pi/master/install.sh | sudo bash

#voy a la carpeta donde voy a alojar el servicio
cd /home/pi/

#descargo los archivos
sudo git clone https://github.com/Ansel-dal/DCMLocker

#doy permisos para crear dcmdigitalsignage.service 
sudo chmod ugo+rwx /etc/systemd/system/

#creo dcmdigitalsignage.service 
echo -e "[Unit]
Description=dcmdigitalsignage 
[Service]
 WorkingDirectory=/home/pi/DCMLocker
 ExecStart=/opt/dotnet/dotnet /home/pi/DCMLocker/DCMLocker.Server.dll
 Restart=always   
 SyslogIdentifier=dotnet-dcmdigitalsignage    
 User=root
 Environment=ASPNETCORE_ENVIRONMENT=Production 
[Install]
 WantedBy=multi-user.target

" >> /etc/systemd/system/dcmdigitalsignage.service

#creo servicio
sudo systemctl enable dcmdigitalsignage.service

#inico servicio
sudo systemctl start dcmdigitalsignage.service
