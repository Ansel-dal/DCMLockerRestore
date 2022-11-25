#!/bin/bash


#voy a la carpeta donde voy a alojar el servicio
cd /home/pi/

#descargo los archivos
sudo git clone https://github.com/Ansel-dal/DCMLocker

#doy permisos para crear dcmlocker.service 
sudo chmod ugo+rwx /etc/systemd/system/

############ creo dcmlocker.service  ############
#creo archivo que da el arranque
sudo touch /etc/systemd/system/dcmlocker.service
#doy permisos para modificar desde el script
sudo chmod ugo+rwx /etc/systemd/system/dcmlocker.service
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

" > /etc/systemd/system/dcmlocker.service

#creo servicio
sudo systemctl enable dcmlocker.service

#inico servicio
sudo systemctl start dcmlocker.service


############ inicio en chromium ############
#creo archivo que da el arranque
sudo touch /etc/xdg/autostart/display.desktop
#doy permisos para modificar desde el script
sudo chmod ugo+rwx /etc/xdg/autostart/display.desktop
#modifico archivo y agrego instrucciones
echo "[Desktop Entry]
Name=KioskMode #name
Exec=chromium-browser --start-fullscreen --force-device-scale-factor=0.7 --kiosk --app=http://localhost:5022/
" > /etc/xdg/autostart/display.desktop


############ ponemos script al inicio ############
#elimino /etc/rc.local
sudo rm -r /etc/rc.local


#lo creo nuevamente con el script puesto
sudo touch /etc/rc.local
#doy permisos para modificar desde el script
sudo chmod ugo+rwx /etc/rc.local
#edito y agrego instrucciones
echo -e "#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# Print the IP address
_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "My IP address is %s\n" "$_IP"
fi
sudo bash /var/www/dcmlocker/script.sh
exit 0
" > /etc/rc.local
sudo reboot
