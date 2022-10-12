#!/bin/bash

sudo apt-get update
sudo apt-get upgrade
sudo apt install nginx -y
sudo service nginx start


echo -e "


interface eth0
metric 303
static ip_address=192.168.2.3
static routers=192.168.2.1
static domain_name_servers=192.168.2.1


interface wlan0
metric 200
static ip_address=192.168.88.246
static routers=192.168.88.1
static domain_name_servers=192.168.88.1

" >> /etc/dhcpcd.conf

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

#archivo inicio chromium

echo -e "
[Desktop Entry]
Name=KioskMode #name
Exec=chromium-browser --start-fullscreen --disable-pinch  --kiosk --app=http://localhost:5022/


" >> /etc/xdg/autostart/display.desktop

export XAUTHORITY=~/.Xauthority
xset s noblank
xset s off
xset -dpms

sudo reboot
