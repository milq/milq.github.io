# Tutorial: Configuración de Apache HTTP Server en Windows

En este tutorial aprenderás a configurar el servidor web Apache utilizando XAMPP en Windows, abarcando desde la administración de parámetros básicos hasta la implementación de medidas de seguridad avanzadas y la gestión de logs.

> **Nota:** Este tutorial utiliza una instalación separada de XAMPP en `C:\Users\Usuario\xampp` para evitar interferir con una instalación principal de XAMPP que podría estar ubicada en `C:\xampp`. Esto permite practicar y experimentar con Apache HTTP Server sin riesgo para tu entorno principal.

## Paso 1: Instalación y configuración inicial de XAMPP

1. **Descarga XAMPP:**
   - Visita el sitio oficial de [Apache Friends](https://www.apachefriends.org/es/index.html) y descarga la última versión de XAMPP para Windows.

2. **Instala XAMPP:**
   - Ejecuta el instalador descargado.
   - Selecciona los componentes que deseas instalar (asegúrate de incluir Apache).
   - **Cambia el directorio de instalación** a `C:\Users\Usuario\xampp` para no interferir con la instalación principal de XAMPP que podría estar en `C:\xampp`.
   - Completa la instalación siguiendo las indicaciones del asistente.
   - Tras finalizar la instalación, borra todo el contenido de la carpeta `C:\Users\Usuario\xampp\htdocs`.

3. **Inicia los servicios:**
   - Abre el Panel de Control de XAMPP.
   - Inicia el módulo de Apache haciendo clic en "Start".

## Paso 2: Modificar los parámetros de administración más importantes del servidor web

1. **Accede al archivo de configuración:**
   - Navega a `C:\Users\Usuario\xampp\apache\conf\httpd.conf`.
   - Abre `httpd.conf` con un editor de texto como Notepad++.

2. **Parámetros clave:**
   - **`Listen`**: Define el puerto en el que Apache escuchará (por defecto es 80).
   - **`ServerName`**: Especifica el nombre del servidor y el puerto.
   - **`DocumentRoot`**: Indica la carpeta raíz donde se alojan los archivos web.
   - **`<Directory>`**: Configura permisos y opciones para directorios específicos.

3. **Cambia el puerto de escucha (`Listen`):**
   - Abre el archivo `httpd.conf` ubicado en `C:\Users\Usuario\xampp\apache\conf\httpd.conf`.
   - Localiza la línea que comienza con `Listen` y cámbiala si es necesario. Por ejemplo, para cambiar el puerto a **8080**:
     ```apache
     Listen 8080
     ```
   - **Nota:** Asegúrate de que el nuevo puerto no esté siendo utilizado por otra aplicación.

4. **Establece el nombre del servidor (`ServerName`):**
   - En el mismo archivo `httpd.conf`, busca la directiva `ServerName` y configúrala con el nombre adecuado para tu entorno. Por ejemplo:
     ```apache
     ServerName localhost:8080
     ```
   - **Importante:** Debe coincidir con el puerto configurado en la directiva `Listen`.

5. **Configura el tiempo de espera (`Timeout`):**
   - Define cuánto tiempo esperará el servidor por ciertas operaciones antes de cerrar la conexión. Por defecto, suele ser **300 segundos**.
     ```apache
     Timeout 300
     ```
   - **Recomendación:** Ajusta este valor según las necesidades de tu entorno para optimizar el rendimiento.
   - **Nota:** Algunas directivas como `Timeout`, `KeepAlive` u otras pueden no aparecer en `httpd.conf` por defecto, ya que Apache utiliza valores predeterminados. Si no las encuentras, puedes agregarlas manualmente en la sección de configuraciones globales del archivo `httpd.conf` o en archivos incluidos como `httpd-default.conf`.

6. **Ajusta parámetros de KeepAlive:**
   - **KeepAlive:** Permite mantener las conexiones persistentes entre el cliente y el servidor.
     ```apache
     KeepAlive On
     ```
   - **KeepAliveTimeout:** Define el tiempo de espera para mantener la conexión abierta.
     ```apache
     KeepAliveTimeout 5
     ```
   - **MaxKeepAliveRequests:** Establece el número máximo de solicitudes permitidas por conexión persistente.
     ```apache
     MaxKeepAliveRequests 100
     ```

7. **Establece el nivel de registro de logs (`LogLevel`):**
   - Controla la verbosidad de los registros de Apache.
     ```apache
     LogLevel warn
     ```
   - **Opciones comunes:** `debug`, `info`, `notice`, `warn`, `error`, `crit`, `alert`, `emerg`.

8. **Configura el número máximo de clientes simultáneos (`MaxRequestWorkers`):**
   - Limita el número de conexiones simultáneas que Apache puede manejar.
     ```apache
     <IfModule mpm_prefork_module>
         MaxRequestWorkers 150
     </IfModule>
     ```
   - **Nota:** Ajusta este valor según los recursos disponibles del servidor.

9. **Define la página de índice por defecto (`DirectoryIndex`):**
   - Especifica los archivos que Apache buscará por defecto en un directorio.
     ```apache
     DirectoryIndex index.html index.php
     ```

10. **Limita el tamaño máximo de las solicitudes (`LimitRequestBody`):**
   - Restringe el tamaño máximo permitido para el cuerpo de una solicitud.
     ```apache
     LimitRequestBody 10485760
     ```
   - **Ejemplo:** Limita a **15 MB** (15728640 bytes).

11. **Configura la codificación de caracteres (`AddDefaultCharset`):**
   - Establece la codificación predeterminada para los documentos servidos.
     ```apache
     AddDefaultCharset UTF-8
     ```

12. **Activa la compresión (`mod_deflate`):**
    - Permite comprimir contenido antes de enviarlo al cliente, reduciendo el tiempo de carga.
      ```apache
      <IfModule mod_deflate.c>
          AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css application/javascript
      </IfModule>
      ```

13. **Configura redirecciones básicas:**
    - Puedes añadir redirecciones sencillas para manejar el tráfico HTTP a HTTPS, si es necesario.
      ```apache
      <VirtualHost *:80>
          ServerName ejemplo.local
          Redirect permanent / https://ejemplo.local/
      </VirtualHost>
      ```

14. **Reinicia Apache para aplicar los cambios:**
    - Vuelve al Panel de Control de XAMPP y reinicia el módulo de Apache para que las nuevas configuraciones tengan efecto.

## Paso 3: Activar y configurar nuevos módulos

1. **Activa módulos:**
   - En `httpd.conf`, localiza las líneas que empiezan con `LoadModule`.
   - Descomenta (elimina el `#`) los módulos que desees activar, por ejemplo:
     ```apache
     LoadModule rewrite_module modules/mod_rewrite.so
     LoadModule headers_module modules/mod_headers.so
     ```

2. **Configura módulos:**
   - Para `mod_rewrite`, asegúrate de permitir su uso en `.htaccess`:
     ```apache
     <Directory "C:/Users/Usuario/xampp/htdocs">
         AllowOverride All
     </Directory>
     ```

3. **Reinicia Apache:**
   - Vuelve al Panel de Control de XAMPP y reinicia Apache para aplicar los cambios.

## Paso 4: Crear y configurar sitios virtuales

1. **Configura _hosts_ virtuales:**
   - Abre el archivo `httpd-vhosts.conf` ubicado en `C:\Users\Usuario\xampp\apache\conf\extra\httpd-vhosts.conf`.
   
2. **Agrega definiciones de Virtual Hosts:**
   - Añade una entrada para cada sitio virtual, por ejemplo:
     ```apache
     <VirtualHost *:8080>
         ServerAdmin admin@ejemplo.com
         DocumentRoot "C:/Users/Usuario/xampp/htdocs/ejemplo"
         ServerName ejemplo.local
         ErrorLog "logs/ejemplo-error.log"
         CustomLog "logs/ejemplo-access.log" common
     </VirtualHost>
     ```

3. **Actualiza el archivo _hosts_ de Windows:**
   - Abre `C:\Windows\System32\drivers\etc\hosts` con permisos de administrador.
   - Añade líneas para cada sitio virtual:
     ```
     127.0.0.1   ejemplo.local
     ```

4. **Reinicia Apache:**
   - Reinicia Apache para que los cambios surtan efecto.

## Paso 5: Configurar mecanismos de autenticación y control de acceso

1. **Crea una página de ejemplo:**
   - Antes de configurar la autenticación, crea la carpeta `C:\Users\Usuario\xampp\htdocs\ejemplo`, y dentro de ella crea un archivo `index.html` o `index.php` con contenido básico.

2. **Crea un archivo `.htaccess`:**
   - En el directorio del sitio virtual (`C:/Users/Usuario/xampp/htdocs/ejemplo`), crea un archivo `.htaccess` con el siguiente contenido:
     ```apache
     AuthType Basic
     AuthName "Área Restringida"
     AuthUserFile "C:/Users/Usuario/xampp/apache/passwords/.htpasswd"
     Require valid-user
     ```
   - El archivo de configuración de Apache `.htaccess` se ubica en un directorio específico y te permite definir reglas de seguridad, reescrituras, redirecciones y otras directivas centrales sin tener que editar `httpd.conf`.

3. **Crear el archivo de contraseñas `.htpasswd`:**
   - Si no existe, crea la carpeta `passwords\` en `C:\Users\Usuario\xampp\apache\`
   - Utiliza la herramienta `htpasswd` incluida en XAMPP:
     - Abre la línea de comandos y navega a `C:\Users\Usuario\xampp\apache\bin`.
     - Ejecuta:
       ```
       .\htpasswd.exe -c "C:/Users/Usuario/xampp/apache/passwords/.htpasswd" usuario1
       ```
     - Introduce y confirma la contraseña cuando se te solicite.

5. **Prueba la autenticación:**
   - Accede al sitio virtual en el navegador (`http://ejemplo.local`) y verifica que se solicita el usuario y contraseña.

## Paso 6: Obtén e instala certificados digitales con Let's Encrypt usando Certbot

1. **Instala Certbot:**
   - Descarga [Certbot para Windows](https://certbot.eff.org/instructions) y extrae los archivos en una carpeta, por ejemplo, `C:\certbot`.

2. **Obtén el certificado SSL:**
   - Abre la línea de comandos y navega a `C:\certbot`.
   - Ejecuta:
     ```
     certbot certonly --standalone -d ejemplo.local
     ```
   - Sigue las instrucciones para completar la obtención del certificado.

3. **Configura Apache para usar SSL:**
   - Abre `httpd-ssl.conf` ubicado en `C:\Users\Usuario\xampp\apache\conf\extra\httpd-ssl.conf`.
   - Actualiza las rutas de los certificados:
     ```apache
     SSLCertificateFile "C:/certbot/live/ejemplo.local/fullchain.pem"
     SSLCertificateKeyFile "C:/certbot/live/ejemplo.local/privkey.pem"
     ```
   - Asegúrate de que el módulo SSL esté cargado en `httpd.conf`:
     ```apache
     LoadModule ssl_module modules/mod_ssl.so
     ```

4. **Habilita el sitio SSL:**
   - Agrega una directiva para el sitio SSL en `C:\Users\Usuario\xampp\apache\conf\extra\httpd-vhosts.conf`:
     ```apache
     <VirtualHost *:443>
         ServerAdmin admin@ejemplo.com
         DocumentRoot "C:/Users/Usuario/xampp/htdocs/ejemplo"
         ServerName ejemplo.local
         SSLEngine on
         SSLCertificateFile "C:/certbot/live/ejemplo.local/fullchain.pem"
         SSLCertificateKeyFile "C:/certbot/live/ejemplo.local/privkey.pem"
     </VirtualHost>
     ```

5. **Reinicia Apache:**
   - Reinicia Apache para aplicar la configuración SSL.

## Paso 7: Establecer mecanismos para asegurar las comunicaciones

1. **Fuerza el uso de HTTPS:**
   - En el archivo `C:\Users\Usuario\xampp\htdocs\ejemplo\.htaccess`, añade:
     ```apache
     RewriteEngine On
     RewriteCond %{HTTPS} off
     RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
     ```

2. **Configura cabeceras de seguridad:**
   - En `httpd.conf`, añade las siguientes líneas dentro del bloque `<VirtualHost>`:
     ```apache
     Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
     Header set X-Content-Type-Options "nosniff"
     Header set X-Frame-Options "DENY"
     Header set X-XSS-Protection "1; mode=block"
     ```

3. **Deshabilita protocolos inseguros:**
   - En `httpd-ssl.conf`, asegúrate de deshabilitar TLS versiones antiguas:
     ```apache
     SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1
     ```

4. **Reinicia Apache:**
   - Reinicia Apache para aplicar las medidas de seguridad.

## Paso 8: Utiliza tecnologías de gestión de _logs_

1. **Instala una herramienta de gestión de _logs_ (por ejemplo, ELK Stack):**
   - Instala [Elasticsearch](https://www.elastic.co/es/elasticsearch/), [Logstash](https://www.elastic.co/es/logstash/) y [Kibana](https://www.elastic.co/es/kibana/) siguiendo las instrucciones oficiales para Windows.

2. **Configura Apache para enviar _logs_ a Logstash:**
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

4. **Inicia ELK Stack:**
   - Inicia Elasticsearch, Logstash y Kibana.
   - Accede a Kibana en `http://localhost:5601` para visualizar y analizar los logs en tiempo real.

5. **Monitoriza y haz un análisis:**
   - Configura _dashboards_ en Kibana para monitorizar el rendimiento y detectar posibles incidencias en el servidor Apache.
