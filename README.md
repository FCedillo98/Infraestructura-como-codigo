# Script Tomcat

El script **ScriptTomcat10.sh** está preparado para instalar y configurar Tomcat 10 desde Ubuntu 20.04.

---

1. Comprueba si existe el usuario __tomcat__ (que ejecutará Tomcat) y en caso contrario lo crea.
2. Instala la versión 17 de JDK.
3. Instala Tomcat 10, dándole permisos al usuario __tomcat__.
4. Configura el fichero __/opt/tomcat/conf/tomcat-users.xml__ para ganar acceso como __Manager__ y __Host Manager__, así como poder modificar sus contraseñas.
5. Elimina las restricciones de acceso a la página __Manager__ modificando el fichero __/opt/tomcat/webapps/manager/META-INF/context.xml__.
6. Elimina las restricciones de acceso a la página __Host Manager__ modificando el fichero __/opt/tomcat/webapps/host-manager/META-INF/context.xml__.
7. Crea el servicio de Tomcat en el fichero __/etc/systemd/system/tomcat.service__ asignandole valores a las variables de entorno.
8. Recarga el servicio para guardar los cambios, activa Tomcat para que se inicie con el sistema y lo lanza, permitiendo acceso mediante el puerto 8080.

