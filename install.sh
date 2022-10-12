#!/bin/bash

sudo apt-get update
sudo apt-get upgrade
sudo apt install nginx -y
sudo service nginx start


sudo wget -O - https://raw.githubusercontent.com/pjgpetecodes/dotnet5pi/master/install.sh | sudo bash


#voy a la carpeta donde voy a alojar el servicio
cd /home/pi/

#descargo los archivos
sudo git clone https://github.com/Ansel-dal/DCMLocker

#doy permisos para crear dcmlocker.service 
sudo chmod ugo+rwx /etc/systemd/system/

#creo dcmlocker.service 
echo -e "[Unit]
Description=dcmlocker 
[Service]
 WorkingDirectory=/home/pi/DCMLocker
 ExecStart=/opt/dotnet/dotnet /home/pi/DCMLocker/DCMLocker.Server.dll
 Restart=always   
 SyslogIdentifier=dotnet-dcmlocker    
 User=root
 Environment=ASPNETCORE_ENVIRONMENT=Production 
[Install]
 WantedBy=multi-user.target

" >> /etc/systemd/system/dcmlocker.service

#creo servicio
sudo systemctl enable dcmlocker.service

#inico servicio
sudo systemctl start dcmlocker.service
