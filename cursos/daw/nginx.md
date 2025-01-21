# Tutorial 2: Configuración de Nginx en Windows

En este tutorial aprenderás a configurar el servidor web Nginx en Windows, abarcando desde la administración de parámetros básicos hasta la implementación de medidas de seguridad avanzadas y la gestión de logs.

## Paso 1: Instalación y configuración inicial de Nginx

1. **Descarga Nginx para Windows:**
   - Visita el sitio oficial de [Nginx](http://nginx.org/en/download.html) y descarga la versión estable para Windows.

2. **Instala Nginx:**
   - Extrae el contenido del archivo ZIP descargado en una carpeta, por ejemplo, `C:\nginx`.

3. **Inicia Nginx:**
   - Abre la línea de comandos y navega a `C:\nginx`.
   - Ejecuta `nginx.exe` para iniciar el servidor.

4. **Verifica la instalación:**
   - Abre un navegador y accede a `http://localhost`. Deberías ver la página de bienvenida de Nginx.

## Paso 2: Modificar los parámetros de administración más importantes del servidor web

1. **Accede al archivo de configuración:**
   - Abre `C:\nginx\conf\nginx.conf` con un editor de texto como Notepad++.

2. **Parámetros clave:**
   - **`worker_processes`**: Define el número de procesos de trabajo (usualmente igual al número de núcleos de CPU).
   - **`listen`**: Especifica el puerto en el que Nginx escuchará (por defecto es 80).
   - **`server_name`**: Define el nombre del servidor.
   - **`root`**: Indica la carpeta raíz donde se alojan los archivos web.

3. **Modifica parámetros básicos:**
   - Ajusta `worker_processes` según tu hardware.
   - Configura `server_name` para que coincida con tu dominio o dirección local.

4. **Ajusta el número de procesos de trabajo (`worker_processes`):**
   - Abre el archivo `nginx.conf` ubicado en `C:\nginx\conf\nginx.conf`.
   - Configura `worker_processes` según el número de núcleos de CPU de tu máquina.
     ```nginx
     worker_processes 4;
     ```
   - **Recomendación:** Un valor igual al número de núcleos de CPU suele ser óptimo.

5. **Configura el nombre del servidor (`server_name`):**
   - Define el nombre del servidor para que coincida con tu dominio o dirección local.
     ```nginx
     server_name ejemplo.local;
     ```

6. **Define el número máximo de conexiones por proceso de trabajo (`worker_connections`):**
   - Establece cuántas conexiones simultáneas puede manejar cada proceso de trabajo.
     ```nginx
     events {
         worker_connections 1024;
     }
     ```
   - **Nota:** Ajusta este valor según la carga esperada y los recursos del servidor.

7. **Configura el tiempo de espera para Keep-Alive (`keepalive_timeout`):**
   - Define cuánto tiempo Nginx mantendrá abierta una conexión persistente.
     ```nginx
     keepalive_timeout 65;
     ```

8. **Establece el tamaño máximo de cuerpo de solicitud (`client_max_body_size`):**
   - Limita el tamaño máximo permitido para el cuerpo de una solicitud.
     ```nginx
     client_max_body_size 10M;
     ```
   - **Ejemplo:** Limita a **10 MB**.

9. **Configura los logs de acceso y error (`access_log` y `error_log`):**
   - Define dónde se almacenarán los registros de acceso y errores.
     ```nginx
     access_log  C:/nginx/logs/access.log;
     error_log   C:/nginx/logs/error.log warn;
     ```
   - **Nivel de Registro:** Puedes ajustar el nivel de `error_log` (por ejemplo, `debug`, `info`, `notice`, `warn`, `error`, `crit`, `alert`, `emerg`).

10. **Habilita la compresión GZIP:**
   - Reduce el tamaño de los archivos enviados al cliente, mejorando los tiempos de carga.
     ```nginx
     gzip on;
     gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
     gzip_min_length 256;
     ```

11. **Optimiza la transferencia de archivos (`sendfile`):**
   - Mejora el rendimiento al permitir la transferencia eficiente de archivos.
     ```nginx
     sendfile on;
     tcp_nopush on;
     tcp_nodelay on;
     ```

12. **Configura la gestión de errores personalizados (`error_page`):**
   - Define páginas de error personalizadas para diferentes códigos de estado HTTP.
     ```nginx
     error_page 404 /404.html;
     location = /404.html {
         root   C:/nginx/html;
         internal;
     }
     ```

13. **Define la página de índice por defecto (`index`):**
    - Especifica los archivos que Nginx buscará por defecto en un directorio.
      ```nginx
      index index.html index.htm index.php;
      ```

14. **Configura la seguridad básica (`server_tokens`):**
    - Oculta la versión de Nginx para mejorar la seguridad.
      ```nginx
      server_tokens off;
      ```

15. **Reinicia Nginx para aplicar los cambios:**
    - Abre la línea de comandos, navega a `C:\nginx` y ejecuta:
      ```
      nginx -s reload
      ```
    - **Alternativa:** Detén y vuelve a iniciar Nginx si encuentras problemas al recargar.



## Paso 3: Activar y configurar nuevos módulos

1. **Habilita módulos en Nginx:**
   - Nginx en Windows tiene módulos precompilados limitados. Para funcionalidades adicionales, considera recompilar Nginx con los módulos deseados o utilizar alternativas como scripts externos.

2. **Ejemplo: Configura el módulo de reescritura (Rewrite):**
   - En el bloque `server`, añade reglas de reescritura según tus necesidades. Por ejemplo:
     ```nginx
     location / {
         try_files $uri $uri/ =404;
     }

     location /oldpath/ {
         rewrite ^/oldpath/(.*)$ /newpath/$1 permanent;
     }
     ```

3. **Reinicia Nginx:**
   - Ejecuta `nginx -s reload` en la línea de comandos para aplicar los cambios.

## Paso 4: Crear y configurar sitios virtuales

1. **Configura _hosts_ virtuales:**
   - En `nginx.conf`, dentro del bloque `http`, incluye configuraciones para múltiples servidores:
     ```nginx
     http {
         ...
         include       conf/sites-enabled/*.conf;
         ...
     }
     ```

2. **Crea directorios para sitios:**
   - Crea las carpetas `C:\nginx\conf\sites-available` y `C:\nginx\conf\sites-enabled`.

3. **Crea configuraciones de sitios virtuales:**
   - Crea un archivo `ejemplo.conf` en `sites-available` con:
     ```nginx
     server {
         listen       80;
         server_name  ejemplo.local;

         location / {
             root   C:/nginx/html/ejemplo;
             index  index.html index.htm;
         }

         error_page  404              /404.html;
         location = /404.html {
             root   C:/nginx/html;
         }
     }
     ```

4. **Habilita los sitios virtuales:**
   - Crea un enlace simbólico o simplemente copia el archivo `ejemplo.conf` a `sites-enabled`.

5. **Actualiza el archivo _hosts_ de Windows:**
   - Abre `C:\Windows\System32\drivers\etc\hosts` con permisos de administrador.
   - Añade:
     ```
     127.0.0.1   ejemplo.local
     ```

6. **Reinicia Nginx:**
   - Ejecuta `nginx -s reload` para aplicar la nueva configuración.

## Paso 5: Configurar Mecanismos de Autenticación y Control de Acceso

1. **Instala `htpasswd` para crear archivos de contraseñas:**
   - Descarga [htpasswd para Windows](https://httpd.apache.org/docs/2.4/programs/htpasswd.html) o utiliza herramientas compatibles para generar el archivo `.htpasswd`.

2. **Crea el archivo `.htpasswd`:**
   - Ejecuta en la línea de comandos:
     ```
     htpasswd -c C:\nginx\conf\.htpasswd usuario1
     ```
   - Introduce y confirma la contraseña.

3. **Configura la autenticación en Nginx:**
   - En el archivo de configuración del sitio virtual (`ejemplo.conf`), añade:
     ```nginx
     location /protected/ {
         auth_basic "Área Restringida";
         auth_basic_user_file C:/nginx/conf/.htpasswd;
     }
     ```

4. **Prueba la autenticación:**
   - Accede a `http://ejemplo.local/protected/` y verifica que se solicita el usuario y contraseña.

## Paso 6: Obtener e instalar certificados digitales con Let's Encrypt usando Certbot

1. **Instala Certbot para Windows:**
   - Descarga [Certbot para Windows](https://certbot.eff.org/instructions?ws=other&os=windows) y extrae los archivos en una carpeta, por ejemplo, `C:\certbot`.

2. **Obtén el certificado SSL:**
   - Abre la línea de comandos y navega a `C:\certbot`.
   - Ejecuta:
     ```
     certbot certonly --standalone -d ejemplo.local
     ```
   - Sigue las instrucciones para completar la obtención del certificado.

3. **Configura Nginx para usar SSL:**
   - Abre el archivo de configuración del sitio virtual (`ejemplo.conf`) y añade:
     ```nginx
     server {
         listen              443 ssl;
         server_name         ejemplo.local;

         ssl_certificate     C:/certbot/live/ejemplo.local/fullchain.pem;
         ssl_certificate_key C:/certbot/live/ejemplo.local/privkey.pem;

         location / {
             root   C:/nginx/html/ejemplo;
             index  index.html index.htm;
         }

         error_page  404              /404.html;
         location = /404.html {
             root   C:/nginx/html;
         }
     }
     ```

4. **Fuerza HTTPS:**
   - En el bloque `server` que escucha en el puerto 80, añade una redirección a HTTPS:
     ```nginx
     server {
         listen       80;
         server_name  ejemplo.local;
         return       301 https://$server_name$request_uri;
     }
     ```

5. **Reinicia Nginx:**
   - Ejecuta `nginx -s reload` para aplicar la configuración SSL.

## Paso 7: Establecer mecanismos para asegurar las comunicaciones

1. **Configura cabeceras de seguridad:**
   - En el bloque `server` de HTTPS, añade:
     ```nginx
     add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
     add_header X-Content-Type-Options "nosniff" always;
     add_header X-Frame-Options "DENY" always;
     add_header X-XSS-Protection "1; mode=block" always;
     ```

2. **Deshabilita protocolos inseguros:**
   - Añade al bloque `server` de HTTPS:
     ```nginx
     ssl_protocols TLSv1.2 TLSv1.3;
     ssl_prefer_server_ciphers on;
     ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384";
     ```

3. **Implementa protección contra ataques DDoS básicos:**
   - Utiliza módulos como `limit_req`:
     ```nginx
     http {
         limit_req_zone $binary_remote_addr zone=mylimit:10m rate=10r/s;

         server {
             location / {
                 limit_req zone=mylimit burst=20;
                 ...
             }
         }
     }
     ```

4. **Reinicia Nginx:**
   - Ejecuta `nginx -s reload` para aplicar las medidas de seguridad.

## Paso 8: Implantación de aplicaciones en el servidor web

1. **Prepara la aplicación:**
   - Asegúrate de que la aplicación web sea compatible con Nginx y cumple con los requisitos necesarios.

2. **Configura el servidor para la aplicación:**
   - En el archivo de configuración del sitio virtual (`ejemplo.conf`), configura las directivas necesarias para la aplicación, por ejemplo, para aplicaciones PHP:
     ```nginx
     location ~ \.php$ {
         fastcgi_pass   127.0.0.1:9000;
         fastcgi_index  index.php;
         fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
         include        fastcgi_params;
     }
     ```

3. **Inicia servicios adicionales (si es necesario):**
   - Por ejemplo, inicia PHP-FPM si tu aplicación lo requiere.

4. **Prueba la aplicación:**
   - Accede a la URL correspondiente y verifica que la aplicación funcione correctamente.

## Paso 9: Utilizar tecnologías de virtualización y gestión de _logs_

1. **Configura _logs_ en Nginx:**
   - En el archivo de configuración del sitio virtual (`ejemplo.conf`), asegúrate de que las directivas `access_log` y `error_log` estén definidas:
     ```nginx
     access_log  C:/nginx/logs/ejemplo_access.log;
     error_log   C:/nginx/logs/ejemplo_error.log;
     ```

2. **Instala una herramienta de gestión de _logs_ (por ejemplo, ELK Stack):**
   - Instala [Elasticsearch](https://www.elastic.co/es/elasticsearch/), [Logstash](https://www.elastic.co/es/logstash/) y [Kibana](https://www.elastic.co/es/kibana/) siguiendo las instrucciones oficiales para Windows.

3. **Configura Logstash para Nginx:**
   - Crea un archivo de configuración `nginx.conf` en `C:/logstash/conf.d/` con:
     ```conf
     input {
       file {
         path => "C:/nginx/logs/*.log"
         start_position => "beginning"
         sincedb_path => "NUL"
       }
     }
     filter {
       grok {
         match => { "message" => "%{COMBINEDAPACHELOG}" }
       }
     }
     output {
       elasticsearch {
         hosts => ["localhost:9200"]
         index => "nginx-logs-%{+YYYY.MM.dd}"
       }
       stdout { codec => rubydebug }
     }
     ```

4. **Inicia ELK Stack:**
   - Inicia Elasticsearch, Logstash y Kibana.
   - Accede a Kibana en `http://localhost:5601` para visualizar y analizar los logs en tiempo real.

5. **Monitoriza y haz un análisis:**
   - Configura _dashboards_ en Kibana para monitorizar el rendimiento y detectar posibles incidencias en el servidor Nginx.
