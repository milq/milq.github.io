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
      <VirtualHost *:8080>
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

## Paso 6: Crear certificados locales para `localhost` o `ejemplo.local`

Cuando necesitas cifrar tu tráfico con HTTPS en un entorno de desarrollo o pruebas (por ejemplo, para `localhost` o un dominio interno como `ejemplo.local`), **Let's Encrypt no te emitirá un certificado** si el dominio no es público. Aquí tienes **dos opciones** para usar certificados en local:

### Opción A: Certificado autofirmado

1. **Verifica que OpenSSL esté disponible**  
   - Normalmente XAMPP incluye OpenSSL en:
     ```
     C:\Users\Usuario\xampp\apache\bin\openssl.exe
     ```
   - Si no lo tienes, instálalo desde [slproweb.com/products/Win32OpenSSL.html](https://slproweb.com/products/Win32OpenSSL.html).

2. **Genera una clave privada y un certificado autofirmado**  
   - Abre una consola (CMD/PowerShell) y ve a la carpeta donde quieras guardar los archivos, por ejemplo:
     ```powershell
     cd C:\Users\Usuario\xampp\apache\conf\ssl
     ```
     (Crea la carpeta `ssl` si no existe).

   - Ejecuta:
     ```powershell
     openssl req -x509 -nodes -days 365 -newkey rsa:2048 `
       -keyout localhost.key `
       -out localhost.crt
     ```
   - Rellena los datos que te pida OpenSSL; en el campo **Common Name** pon `localhost` o `ejemplo.local` según necesites.

3. **Configura Apache**  
   - Asegúrate de tener habilitado SSL en `httpd.conf`:
     ```apache
     LoadModule ssl_module modules/mod_ssl.so
     Include conf/extra/httpd-ssl.conf
     ```
   - Edita `httpd-ssl.conf` (o el `<VirtualHost *:443>` que uses) para apuntar a tus archivos:
     ```apache
     <VirtualHost _default_:443>
       DocumentRoot "C:/Users/Usuario/xampp/htdocs"
       ServerName localhost:443

       SSLEngine on
       SSLCertificateFile "C:/Users/Usuario/xampp/apache/conf/ssl/localhost.crt"
       SSLCertificateKeyFile "C:/Users/Usuario/xampp/apache/conf/ssl/localhost.key"
     </VirtualHost>
     ```
   - Reinicia Apache y visita `https://localhost/` o `https://ejemplo.local/`.

   > **Aviso de seguridad en el navegador:**  
   > Al ser un certificado autofirmado, tu navegador mostrará una advertencia. Para eliminarla en tu equipo, instala manualmente el `.crt` en el almacén de certificados de confianza.

### Opción B: Crear una CA local y firmar tus certificados

Si en tu red local necesitas varios certificados (por ejemplo, `sub1.local`, `sub2.local`, etc.) y no quieres aviso de seguridad en cada uno, puedes convertirte en tu propia **Autoridad Certificadora** (CA) interna:

1. **Genera la CA**  
   ```powershell
   openssl genrsa -out myCA.key 2048
   openssl req -x509 -new -nodes -key myCA.key -sha256 -days 3650 -out myCA.crt
   ```
   - `myCA.key`: clave privada de la CA  
   - `myCA.crt`: certificado raíz de la CA

2. **Instala la CA en tu sistema**  
   - En Windows, haz doble clic en `myCA.crt` y selecciona **Instalar certificado** → **Autoridades de certificación raíz de confianza**.  
   - Así, tus navegadores locales confiarán en todos los certificados firmados por esta CA.

3. **Crea el CSR (Certificate Signing Request) para tu dominio**  
   ```powershell
   openssl genrsa -out ejemplo_local.key 2048
   openssl req -new -key ejemplo_local.key -out ejemplo_local.csr
   ```
   - El **Common Name** aquí debe ser `ejemplo.local`.

4. **Firma el CSR con tu CA**  
   ```powershell
   openssl x509 -req -in ejemplo_local.csr -CA myCA.crt -CAkey myCA.key -CAcreateserial -out ejemplo_local.crt -days 365 -sha256
   ```
   - Obtendrás `ejemplo_local.crt` firmado por tu CA local.

5. **Configura Apache** (similar al caso autofirmado):
   ```apache
   SSLEngine on
   SSLCertificateFile "C:/Users/Usuario/xampp/apache/conf/ssl/ejemplo_local.crt"
   SSLCertificateKeyFile "C:/Users/Usuario/xampp/apache/conf/ssl/ejemplo_local.key"
   SSLCertificateChainFile "C:/Users/Usuario/xampp/apache/conf/ssl/myCA.crt"
   ```
   Reinicia Apache y, puesto que tu sistema confía en `myCA.crt`, no tendrás advertencias de seguridad.

## Paso 6 (a extinguir): Obtén e instala certificados digitales con Let's Encrypt en Windows (pendiente de resolver)

> **Nota:** Sólo es válido si tu dominio **es público** (por ejemplo, `midominio.com`).

1. **Estudia a fondo la iniciativa de [Let's Encrypt](https://en.wikipedia.org/wiki/Let%27s_Encrypt)**  
   - Antes de proceder con la configuración, es importante conocer qué es Let's Encrypt: *Let's Encrypt es una autoridad certificadora sin fines de lucro operada por el Internet Security Research Group (ISRG), que proporciona certificados X.509 para cifrado TLS sin costo. Es la autoridad certificadora más grande del mundo, utilizada por más de 400 millones de sitios web, y su objetivo es que todos los sitios web sean seguros y utilicen HTTPS.*

2. **Conoce el protocolo ACME**  
   - El proceso de emisión y renovación automática de certificados se basa en el [protocolo ACME (Automatic Certificate Management Environment)](https://en.wikipedia.org/wiki/Automatic_Certificate_Management_Environment). ACME simplifica la validación de la propiedad del dominio y la instalación de certificados, reduciendo la complejidad de la gestión SSL/TLS.

3. **Descarga e instala una herramienta alternativa a Certbot**  
   - Dado que Certbot ha [discontinuado el soporte para Windows](https://community.letsencrypt.org/t/certbot-discontinuing-windows-beta-support-in-2024/208101) a partir de febrero de 2024, se recomienda usar [*win-acme*](https://www.win-acme.com/) para obtener certificados de Let's Encrypt en Windows.  
   - Visita la página oficial de [*win-acme*](https://www.win-acme.com/) y descarga la versión más reciente para tu sistema operativo.  
   - Descomprime el archivo descargado en una carpeta, por ejemplo: `C:\win-acme`.
   - Si tienes problemas usando *win-acme*, puedes hacerlo con [Certify The Web](https://certifytheweb.com)

4. **Ejecuta *win-acme* para obtener tu certificado**  
   - Abre una ventana de **Símbolo del sistema** o **PowerShell** con permisos de administrador.  
   - Navega hasta la carpeta de win-acme:  
     ```powershell
     cd C:\win-acme
     ```
   - Ejecuta *wacs.exe* para iniciar el asistente interactivo. Si solo deseas un certificado para tu sitio web (por ejemplo, `ejemplo.local`), el asistente te guiará para:
     1. Especificar el dominio (o dominios).  
     2. Validar la propiedad del dominio mediante un desafío HTTP o DNS.  
     3. Guardar el certificado y la clave privada en la ubicación de tu elección.  
   
   > **Nota**: Para que la validación HTTP funcione correctamente, tu servidor Apache debe poder responder a las solicitudes en el dominio configurado. Asegúrate de que los puertos apropiados estén abiertos en el _firewall_ (por defecto, el puerto 80 para HTTP y 443 para HTTPS).

5. **Configura Apache para usar el certificado**  
   Una vez que *win-acme* haya generado el certificado y la clave privada, edita tu archivo de configuración SSL de Apache. Generalmente, se encuentra en:  
   ```
   C:\Users\Usuario\xampp\apache\conf\extra\httpd-ssl.conf
   ```  
   Asegúrate de incluir y apuntar a los archivos generados por win-acme. Por ejemplo:
   ```apache
   SSLCertificateFile "C:/win-acme/keys/ejemplo.local/cert.pem"
   SSLCertificateKeyFile "C:/win-acme/keys/ejemplo.local/privkey.pem"
   SSLCertificateChainFile "C:/win-acme/keys/ejemplo.local/chain.pem"
   ```
   - Verifica también que tengas habilitado el módulo SSL en `httpd.conf`:  
     ```apache
     LoadModule ssl_module modules/mod_ssl.so
     ```
   - Si usas Virtual Hosts para HTTPS, configura un bloque `<VirtualHost *:443>` que apunte a los certificados correspondientes:
     ```apache
     <VirtualHost *:443>
         ServerAdmin admin@ejemplo.com
         DocumentRoot "C:/Users/Usuario/xampp/htdocs/ejemplo"
         ServerName ejemplo.local
         SSLEngine on
         SSLCertificateFile "C:/win-acme/keys/ejemplo.local/cert.pem"
         SSLCertificateKeyFile "C:/win-acme/keys/ejemplo.local/privkey.pem"
         SSLCertificateChainFile "C:/win-acme/keys/ejemplo.local/chain.pem"
     </VirtualHost>
     ```

6. **Reinicia Apache**  
   Para que los cambios surtan efecto, ve al **Panel de Control de XAMPP** y reinicia el servicio de **Apache**.

7. **Verifica la instalación**  
   - Abre tu navegador y visita `https://ejemplo.local`.  
   - Comprueba que el certificado sea válido y que la conexión sea segura.  
   - **Consejo de seguridad**: asegura la renovación automática de tu certificado. Win-acme permite configurar tareas programadas en Windows para renovaciones automáticas (generalmente cada 60 días). Así, tu sitio siempre estará protegido por un certificado vigente de Let's Encrypt.

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
