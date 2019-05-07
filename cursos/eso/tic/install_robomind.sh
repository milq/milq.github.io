echo 'Instalación de RoboMind (execute as Root)'
wget https://www.robomind.net/download/generic/RoboMind7.0.zip
unzip RoboMind7.0.zip
mv RoboMind /opt
echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list
apt-get update
apt-get install -y openjdk-11-jre

echo "[Desktop Entry]" > /usr/share/applications/Robomind.desktop
echo "Name=RoboMind" >> /usr/share/applications/Robomind.desktop
echo "Exec=bash robomind.sh" >> /usr/share/applications/Robomind.desktop
echo "Path=/opt/RoboMind" >> /usr/share/applications/Robomind.desktop
echo "Icon=/opt/RoboMind/robo.ico" >> /usr/share/applications/Robomind.desktop
echo "Categories=Application;Education;Development;ComputerScience;" >> /usr/share/applications/Robomind.desktop

