#!/bin/bash
# -----------------------------------
# Script de instalación de Tomcat 10
# -----------------------------------

# Creación de usuario sin privilegios para correr Tomcat
# Comprobar si el usuario tomcat existe y crearlo en caso contrario
id tomcat || useradd -m -d /opt/tomcat -U -s /bin/false tomcat

# Actualización del sistema
apt-get update -y
apt-get upgrade -y

#Instalación de la versión de java necesaria
apt-get install openjdk-17-jre -y

# Descaragr el archivo de instalación de Tomcat
cd /tmp
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.18/bin/apache-tomcat-10.1.18.tar.gz

#Extraer el archivo Tomcat
tar xzvf apache-tomcat-10*tar.gz -C /opt/tomcat --strip-components=1

# Se le dan permisos al usuario tomcat sobre el archivo descargado y extraido
chown -R tomcat:tomcat /opt/tomcat/
chmod -R u+x /opt/tomcat/bin

# Definimos usuarios que permitan acceso al Manager y al HostManager
sed -i 's/<\/tomcat-users>/	<role rolename="manager-gui" \/>/' /opt/tomcat/conf/tomcat-users.xml
echo '    <user username="manager" password="manager_password" roles="manager-gui" />' | tee -a /opt/tomcat/conf/tomcat-users.xml
echo '    <role rolename="admin-gui" />' | tee -a /opt/tomcat/conf/tomcat-users.xml
echo '    <user username="admin" password="admin_password" roles="manager-gui,admin-gui" />' | tee -a /opt/tomcat/conf/tomcat-users.xml
echo '</tomcat-users>' | tee -a /opt/tomcat/conf/tomcat-users.xml

# Eliminar restricciones de la página Manager comentando la línea Valve
sed -i 's/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/<!--  <Valve className="org.apache.catalina.valves.RemoteAddrValve"/' /opt/tomcat/webapps/manager/META-INF/context.xml
sed -i 's/allow="127\\.\\d+\\.\\d+\\.\\d+|::1|0:0:0:0:0:0:0:1" \/>/allow="127\\.\\d+\\.\\d+\\.\\d+|::1|0:0:0:0:0:0:0:1" \/> -->/' /opt/tomcat/webapps/manager/META-INF/context.xml

# Eliminar restricciones de la página HostManager comentando la línea Valve
sed -i 's/<Valve className=\"org.apache.catalina.valves.RemoteAddrValve\"/<!--  <Valve className=\"org.apache.catalina.valves.RemoteAddrValve\"/' /opt/tomcat/webapps/host-manager/META-INF/context.xml
sed -i 's/allow="127\\.\\d+\\.\\d+\\.\\d+|::1|0:0:0:0:0:0:0:1" \/>/allow="127\\.\\d+\\.\\d+\\.\\d+|::1|0:0:0:0:0:0:0:1" \/> -->/' /opt/tomcat/webapps/host-manager/META-INF/context.xml

# Creamos el fichero tomcat.service
echo '[Unit]' | tee -a  /etc/systemd/system/tomcat.service
echo 'Description=Tomcat' | tee -a  /etc/systemd/system/tomcat.service
echo 'After=network.target' | tee -a  /etc/systemd/system/tomcat.service
echo '' | tee -a  /etc/systemd/system/tomcat.service
echo '[Service]' | tee -a  /etc/systemd/system/tomcat.service
echo 'Type=forking' | tee -a  /etc/systemd/system/tomcat.service
echo '' | tee -a  /etc/systemd/system/tomcat.service
echo 'User=tomcat' | tee -a  /etc/systemd/system/tomcat.service
echo 'Group=tomcat' | tee -a  /etc/systemd/system/tomcat.service
echo '' | tee -a  /etc/systemd/system/tomcat.service
echo 'Environment="/usr/lib/jvm/java-1.17.0-openjdk-amd64"' | tee -a  /etc/systemd/system/tomcat.service
echo 'Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"' | tee -a  /etc/systemd/system/tomcat.service
echo 'Environment="CATALINA_BASE=/opt/tomcat"' | tee -a  /etc/systemd/system/tomcat.service
echo 'Environment="CATALINA_HOME=/opt/tomcat"' | tee -a  /etc/systemd/system/tomcat.service
echo 'Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"' | tee -a  /etc/systemd/system/tomcat.service
echo 'Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"' | tee -a  /etc/systemd/system/tomcat.service
echo '' | tee -a  /etc/systemd/system/tomcat.service
echo 'ExecStart=/opt/tomcat/bin/startup.sh' | tee -a  /etc/systemd/system/tomcat.service
echo 'ExecStop=/opt/tomcat/bin/shutdown.sh' | tee -a  /etc/systemd/system/tomcat.service
echo '' | tee -a  /etc/systemd/system/tomcat.servicels

echo 'RestartSec=10' | tee -a  /etc/systemd/system/tomcat.service
echo 'Restart=always' | tee -a  /etc/systemd/system/tomcat.service
echo '' | tee -a  /etc/systemd/system/tomcat.service
echo '[Install]' | tee -a  /etc/systemd/system/tomcat.service
echo 'WantedBy=multi-user.target' | tee -a  /etc/systemd/system/tomcat.service

# Recargar el systemd daemon
systemctl daemon-reload

# Arrancar el systemd daemon
systemctl start tomcat

# Activa Tomcat para que arranque con el sistema
systemctl enable tomcat

# Permite tráfico en el puerto
ufw allow 8080









