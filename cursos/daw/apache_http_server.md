# Tutorial: Configuración de Apache HTTP Server con XAMPP en Windows

En este tutorial aprenderás a configurar el servidor web Apache utilizando XAMPP en Windows, abarcando desde la administración de parámetros básicos hasta la implementación de medidas de seguridad avanzadas y la gestión de logs.

## Paso 1: Instalación y Configuración Inicial de XAMPP

1. **Descargar XAMPP:**
   - Visita el sitio oficial de [Apache Friends](https://www.apachefriends.org/es/index.html) y descarga la última versión de XAMPP para Windows.

2. **Instalar XAMPP:**
   - Ejecuta el instalador descargado.
   - Selecciona los componentes que deseas instalar (asegúrate de incluir Apache).
   - Elige el directorio de instalación (por defecto suele ser `C:\xampp`).
   - Completa la instalación siguiendo las indicaciones del asistente.

3. **Iniciar los Servicios:**
   - Abre el Panel de Control de XAMPP.
   - Inicia el módulo de Apache haciendo clic en "Start".

## Paso 2: Reconocer los Parámetros de Administración más Importantes del Servidor Web

1. **Acceder al Archivo de Configuración:**
   - Navega a `C:\xampp\apache\conf\httpd.conf`.
   - Abre `httpd.conf` con un editor de texto como Notepad++.

2. **Parámetros Clave:**
   - **`Listen`**: Define el puerto en el que Apache escuchará (por defecto es 80).
   - **`ServerName`**: Especifica el nombre del servidor y el puerto.
   - **`DocumentRoot`**: Indica la carpeta raíz donde se alojan los archivos web.
   - **`<Directory>`**: Configura permisos y opciones para directorios específicos.

3. **Modificar Parámetros Básicos:**
   - Cambia el puerto si es necesario (por ejemplo, a 8080).
   - Establece el `ServerName` adecuado para tu entorno.

## Paso 3: Ampliar la Funcionalidad del Servidor mediante la Activación y Configuración de Módulos

1. **Activar Módulos:**
   - En `httpd.conf`, localiza las líneas que empiezan con `LoadModule`.
   - Descomenta (elimina el `#`) los módulos que desees activar, por ejemplo:
     ```apache
     LoadModule rewrite_module modules/mod_rewrite.so
     LoadModule headers_module modules/mod_headers.so
     ```

2. **Configurar Módulos:**
   - Para `mod_rewrite`, asegúrate de permitir su uso en `.htaccess`:
     ```apache
     <Directory "C:/xampp/htdocs">
         AllowOverride All
     </Directory>
     ```

3. **Reiniciar Apache:**
   - Vuelve al Panel de Control de XAMPP y reinicia Apache para aplicar los cambios.

## Paso 4: Crear y Configurar Sitios Virtuales

1. **Configurar Hosts Virtuales:**
   - Abre el archivo `httpd-vhosts.conf` ubicado en `C:\xampp\apache\conf\extra\httpd-vhosts.conf`.
   
2. **Agregar Definiciones de Virtual Hosts:**
   - Añade una entrada para cada sitio virtual, por ejemplo:
     ```apache
     <VirtualHost *:80>
         ServerAdmin admin@ejemplo.com
         DocumentRoot "C:/xampp/htdocs/ejemplo"
         ServerName ejemplo.local
         ErrorLog "logs/ejemplo-error.log"
         CustomLog "logs/ejemplo-access.log" common
     </VirtualHost>
     ```

3. **Actualizar el Archivo Hosts de Windows:**
   - Abre `C:\Windows\System32\drivers\etc\hosts` con permisos de administrador.
   - Añade líneas para cada sitio virtual:
     ```
     127.0.0.1   ejemplo.local
     ```

4. **Reiniciar Apache:**
   - Reinicia Apache para que los cambios surtan efecto.

## Paso 5: Configurar Mecanismos de Autenticación y Control de Acceso

1. **Crear un Archivo `.htaccess`:**
   - En el directorio del sitio virtual (`C:/xampp/htdocs/ejemplo`), crea un archivo `.htaccess` con el siguiente contenido:
     ```apache
     AuthType Basic
     AuthName "Área Restringida"
     AuthUserFile "C:/xampp/apache/passwords/.htpasswd"
     Require valid-user
     ```

2. **Crear el Archivo de Contraseñas `.htpasswd`:**
   - Utiliza la herramienta `htpasswd` incluida en XAMPP:
     - Abre la línea de comandos y navega a `C:\xampp\apache\bin`.
     - Ejecuta:
       ```
       htpasswd -c "C:/xampp/apache/passwords/.htpasswd" usuario1
       ```
     - Introduce y confirma la contraseña cuando se te solicite.

3. **Probar la Autenticación:**
   - Accede al sitio virtual en el navegador (`http://ejemplo.local`) y verifica que se solicita el usuario y contraseña.

## Paso 6: Obtener e Instalar Certificados Digitales con Let's Encrypt

1. **Instalar Certbot:**
   - Descarga [Certbot para Windows](https://certbot.eff.org/instructions) y extrae los archivos en una carpeta, por ejemplo, `C:\certbot`.

2. **Obtener el Certificado SSL:**
   - Abre la línea de comandos y navega a `C:\certbot`.
   - Ejecuta:
     ```
     certbot certonly --standalone -d ejemplo.local
     ```
   - Sigue las instrucciones para completar la obtención del certificado.

3. **Configurar Apache para Usar SSL:**
   - Abre `httpd-ssl.conf` ubicado en `C:\xampp\apache\conf\extra\httpd-ssl.conf`.
   - Actualiza las rutas de los certificados:
     ```apache
     SSLCertificateFile "C:/certbot/live/ejemplo.local/fullchain.pem"
     SSLCertificateKeyFile "C:/certbot/live/ejemplo.local/privkey.pem"
     ```
   - Asegúrate de que el módulo SSL esté cargado en `httpd.conf`:
     ```apache
     LoadModule ssl_module modules/mod_ssl.so
     ```

4. **Habilitar el Sitio SSL:**
   - Agrega una directiva para el sitio SSL en `httpd-vhosts.conf`:
     ```apache
     <VirtualHost *:443>
         ServerAdmin admin@ejemplo.com
         DocumentRoot "C:/xampp/htdocs/ejemplo"
         ServerName ejemplo.local
         SSLEngine on
         SSLCertificateFile "C:/certbot/live/ejemplo.local/fullchain.pem"
         SSLCertificateKeyFile "C:/certbot/live/ejemplo.local/privkey.pem"
     </VirtualHost>
     ```

5. **Reiniciar Apache:**
   - Reinicia Apache para aplicar la configuración SSL.

## Paso 7: Establecer Mecanismos para Asegurar las Comunicaciones

1. **Forzar HTTPS:**
   - En el archivo `.htaccess`, añade:
     ```apache
     RewriteEngine On
     RewriteCond %{HTTPS} off
     RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
     ```

2. **Configurar Cabeceras de Seguridad:**
   - En `httpd.conf`, añade las siguientes líneas dentro del bloque `<VirtualHost>`:
     ```apache
     Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
     Header set X-Content-Type-Options "nosniff"
     Header set X-Frame-Options "DENY"
     Header set X-XSS-Protection "1; mode=block"
     ```

3. **Deshabilitar Protocolos Inseguros:**
   - En `httpd-ssl.conf`, asegúrate de deshabilitar TLS versiones antiguas:
     ```apache
     SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1
     ```

4. **Reiniciar Apache:**
   - Reinicia Apache para aplicar las medidas de seguridad.

## Paso 8: Implantación de Aplicaciones en el Servidor Web

1. **Preparar la Aplicación:**
   - Asegúrate de que la aplicación web esté compatible con Apache y cumpla con los requisitos necesarios.

2. **Configurar Permisos:**
   - Establece los permisos adecuados en los directorios de la aplicación para evitar accesos no autorizados.

3. **Configurar Variables de Entorno (si es necesario):**
   - En `httpd.conf` o en el archivo de configuración del sitio virtual, define las variables de entorno requeridas por la aplicación.

4. **Reiniciar Apache:**
   - Reinicia Apache y prueba la aplicación accediendo a la URL correspondiente.

## Paso 8: Utilizar tecnologías de gestión de Logs

1. **Instalar una Herramienta de Gestión de Logs (por ejemplo, ELK Stack):**
   - Instala [Elasticsearch](https://www.elastic.co/es/elasticsearch/), [Logstash](https://www.elastic.co/es/logstash/) y [Kibana](https://www.elastic.co/es/kibana/) siguiendo las instrucciones oficiales para Windows.

2. **Configurar Apache para Enviar Logs a Logstash:**
   - En `httpd.conf`, añade:
     ```apache
     CustomLog "| C:/logstash/bin/logstash.bat -f C:/logstash/conf.d/apache.conf" combined
     ```

3. **Configurar Logstash:**
   - Crea un archivo de configuración `apache.conf` en `C:/logstash/conf.d/` con:
     ```conf
     input {
       stdin {}
     }
     filter {
       grok {
         match => { "message" => "%{COMBINEDAPACHELOG}" }
       }
     }
     output {
       elasticsearch {
         hosts => ["localhost:9200"]
         index => "apache-logs-%{+YYYY.MM.dd}"
       }
       stdout { codec => rubydebug }
     }
     ```

4. **Iniciar ELK Stack:**
   - Inicia Elasticsearch, Logstash y Kibana.
   - Accede a Kibana en `http://localhost:5601` para visualizar y analizar los logs en tiempo real.

5. **Monitorización y Análisis:**
   - Configura dashboards en Kibana para monitorizar el rendimiento y detectar posibles incidencias en el servidor Apache.
