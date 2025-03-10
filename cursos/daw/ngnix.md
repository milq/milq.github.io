# Tutorial: Configuración de Nginx en Windows usando Docker

Este tutorial es una **continuación** del [Tutorial de Nginx con Docker en Windows](docker-nginx.md) que ya has realizado. Ahora profundizaremos en aspectos de configuración avanzada: desde parámetros esenciales de Nginx, pasando por configuración de hosts virtuales, seguridad (HTTPS, autenticación básica) y gestión de logs. A diferencia de la configuración típica en XAMPP/Apache (como en el ejemplo del tutorial anterior de Apache), aquí usaremos **contenedores Docker** para aislar y desplegar nuestro servidor Nginx.

> **Importante**: Para no interferir con tu contenedor Nginx anterior (`my-nginx`, `custom-nginx`, etc.), crearemos un **nuevo contenedor** totalmente independiente. De esta manera puedes “experimentar” sin afectar la configuración anterior ni tus proyectos en marcha.

## Paso 1: Crear un nuevo contenedor y entorno de trabajo

1. **Descarga (o verifica) la imagen oficial de Nginx**  
   * Si no la tienes ya:
      ```bash
      docker pull nginx
      ```
   * Comprueba con:
   ```bash
   docker images
   ```
   y asegúrate de ver `nginx`.

2. **Prepara una carpeta local para el nuevo contenedor**  
   Crea una carpeta en Windows, por ejemplo:
   ```
   C:\ruta\nginx-avanzado
   ```

3. **Copia la configuración base de Nginx**  
   Crea un contenedor temporal para copiar la configuración por defecto de Nginx y usarla como base:
   ```bash
   docker run -d --name temp-nginx nginx
   docker cp temp-nginx:/etc/nginx C:\ruta\nginx-avanzado\conf-original
   docker rm -f temp-nginx
   ```

4. **Crea y ejecuta el nuevo contenedor**  
   Por ejemplo, si deseas que Nginx escuche en el puerto 8081 de tu Windows:
   ```bash
   docker run -d --name advanced-nginx \
     -p 8081:80 \
     -v C:\ruta\nginx-avanzado\conf:/etc/nginx \
     -v C:\ruta\nginx-avanzado\html:/usr/share/nginx/html \
     -v C:\ruta\nginx-avanzado\logs:/var/log/nginx \
     nginx
   ```
   - `-d`: Inicia en segundo plano.
   - `--name advanced-nginx`: El nombre del contenedor.
   - `-p 8081:80`: Redirige las peticiones de Windows en el puerto `8081` al puerto `80` del contenedor Nginx.
   - Montamos tres volúmenes (conf, html y logs) para edición sencilla desde Windows.

5. **Verifica que esté funcionando**  
   ```bash
   docker ps
   ```
   Debes ver `advanced-nginx` “Up” y el puerto `8081` asignado.  
   Visita en tu navegador:  
   ```
   http://localhost:8081
   ```
   y deberías ver la **página de bienvenida** de Nginx (o un “Hello world” si ya editaste tu `html`).

## Paso 2: Modificar parámetros esenciales de administración en Nginx

La configuración principal de Nginx se encuentra, por defecto, en `/etc/nginx/nginx.conf`. Según cómo organices tus archivos, puedes usar `conf.d` para server blocks adicionales. Vamos a ver algunos parámetros clave (análogo a lo que harías en Apache pero adaptado a la estructura Nginx).

> **Nota**: Como has copiado el contenido base de `/etc/nginx` en `C:\ruta\nginx-avanzado\conf`, tu `nginx.conf` estará en esa carpeta local.

### 1. Cambiar el puerto de escucha

- Por defecto, Nginx escucha en el puerto `80`:
  ```nginx
  server {
      listen 80;
      server_name localhost;
      ...
  }
  ```
- Si deseas cambiarlo a **8080** (por ejemplo):
  ```nginx
  server {
      listen 8080;
      server_name localhost;
      ...
  }
  ```
- Sin embargo, recuerda que Docker ya está exponiendo `80` dentro del contenedor. Si cambias `listen 80` a `listen 8080`, deberás adaptar tu `docker run` o `docker-compose` para exponerlo también (`-p 8080:8080`), o mantener el `listen 80` dentro del contenedor y publicar `8080` en Windows (`-p 8080:80`).

### 2. `server_name`

- En Apache se utiliza `ServerName`; en Nginx, dentro de cada bloque `server` definimos la directiva:
  ```nginx
  server_name ejemplo.local;
  ```
- Esto ayuda a identificar el “host virtual”. Si solo estás usando localhost, puedes dejarlo como `server_name localhost;`.

### 3. Ajustar parámetros de `keepalive_timeout` y otras directivas de conexión

- Para permitir conexiones persistentes y su tiempo de vida:
  ```nginx
  keepalive_timeout 5;
  ```
- Si deseas limitar el máximo de conexiones simultáneas por worker, en la sección `events` de `nginx.conf` se ajusta:
  ```nginx
  events {
      worker_connections 1024;
  }
  ```
  Indica cuántas conexiones puede manejar cada _worker_.

### 4. Definir logs y nivel de detalle

- Nginx, por defecto, define logs en:
  ```nginx
  error_log  /var/log/nginx/error.log warn;
  access_log /var/log/nginx/access.log main;
  ```
- Puedes modificar el nivel:
  ```nginx
  error_log  /var/log/nginx/error.log error;
  ```
  Los niveles van desde `debug`, `info`, `notice`, `warn`, `error`, `crit`, `alert` hasta `emerg`.

- En `http` o `server` context, puedes personalizar el formato del log:
  ```nginx
  log_format custom '$remote_addr - $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent"';
  access_log /var/log/nginx/access.log custom;
  ```

### 5. Limitar el tamaño máximo de las solicitudes

- Similar a `LimitRequestBody` de Apache, en Nginx se usa `client_max_body_size`:
  ```nginx
  client_max_body_size 15M;
  ```
  Esto limitará las subidas a 15 MB.

### 6. Páginas de índice por defecto

- Para indicar la prioridad de los archivos de índice en un directorio:
  ```nginx
  index index.html index.htm index.php;
  ```

### 7. Gzip (equivalente a `mod_deflate` en Apache)

- Para habilitar compresión:
  ```nginx
  gzip on;
  gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
  ```
  Ajusta según los tipos MIME que quieras comprimir.

### 8. Recargar la configuración

- A diferencia de Apache, para **recargar** Nginx sin interrumpir conexiones en curso (graceful reload), ejecuta:
  ```bash
  docker exec -it advanced-nginx nginx -s reload
  ```
  o bien:
  ```bash
  docker kill -s HUP advanced-nginx
  ```
  (Aunque para configuraciones muy profundas, a veces preferirás `docker restart advanced-nginx`).

## Paso 3: Activar módulos (o directivas) en Nginx

Nginx maneja los “módulos” habitualmente compilados dentro de la imagen o cargados de forma dinámica. En la imagen oficial de Docker, muchos módulos comunes (como `rewrite`, `headers_more`, etc.) ya vienen habilitados.

- **Rewrite**: Suele estar disponible de serie. Podemos confirmarlo revisando `/etc/nginx/modules`.
- **Activar directivas específicas**: Basta con usarlas en `nginx.conf` o en tus ficheros en `conf.d`. Por ejemplo:
  ```nginx
  server {
      listen 80;
      server_name ejemplo.local;

      location / {
          rewrite ^/antigua_ruta/?$ /nueva_ruta permanent;
      }
  }
  ```
- Si requieres un módulo no incluido, deberías usar una imagen Nginx que lo contenga (por ejemplo, hay imágenes con `--with-http_auth_request_module` o con `headers_more`). O compilar tu propia imagen Nginx desde un `Dockerfile`.  
  > **Ejemplo** (muy avanzado):  
  > ```dockerfile
  > FROM nginx:alpine
  > RUN apk add --no-cache nginx-mod-http-perl
  > ```
  > Esto añadiría un módulo Nginx en Alpine Linux. Pero, en la mayoría de casos, la imagen oficial cubre lo esencial.

## Paso 4: Configurar servidores virtuales (_server blocks_)

En Apache hablábamos de “Virtual Hosts”. En Nginx, se gestionan en **_server blocks_**. Cada `server` define un sitio distinto, con su propio `server_name`, `root`, logs, etc.

1. **Organiza tus archivos**  
   Normalmente, se colocan en `/etc/nginx/conf.d/` o en `/etc/nginx/sites-available/` (con symlinks a `sites-enabled`) según la distribución. La imagen oficial de Nginx suele incluir la carpeta `conf.d`.

2. **Crea un archivo, por ejemplo `ejemplo.conf`, en `conf.d`**  
   Supongamos `C:\ruta\nginx-avanzado\conf\conf.d\ejemplo.conf`. Dentro:
   ```nginx
   server {
       listen 80;
       server_name ejemplo.local;

       root /usr/share/nginx/html/ejemplo;
       index index.html index.htm;

       error_log  /var/log/nginx/ejemplo-error.log warn;
       access_log /var/log/nginx/ejemplo-access.log main;

       location / {
           # Ajusta directivas o proxy_pass, si fuera necesario
       }
   }
   ```
3. **Edita el archivo `hosts` en Windows (para usar ejemplo.local)**  
   Abre como administrador:  
   ```
   C:\Windows\System32\drivers\etc\hosts
   ```
   Añade:
   ```
   127.0.0.1   ejemplo.local
   ```
   Así, cuando accedas a `http://ejemplo.local`, Windows redirige la petición a `localhost`. Si tu contenedor Nginx está en el puerto 8081, usarás `http://ejemplo.local:8081`.

4. **Crea tu carpeta de sitio**  
   En `C:\ruta\nginx-avanzado\html\ejemplo`, coloca un `index.html`:
   ```html
   <h1>Sitio ejemplo en Nginx</h1>
   ```
5. **Recarga la configuración**  
   ```bash
   docker exec -it advanced-nginx nginx -s reload
   ```
   Prueba en tu navegador:  
   ```
   http://ejemplo.local:8081
   ```
   Verás tu sitio con el index que creaste.

## Paso 5: Configurar autenticación y control de acceso

Al igual que Apache con `.htaccess`, Nginx puede implementar **autenticación básica** a nivel de location o server. No usa `.htaccess`, sino directivas en la configuración.

1. **Crear archivo de contraseñas**  
   - Si tienes la herramienta `htpasswd` instalada en tu Windows (por ejemplo con Git Bash, Cygwin o Windows Subsystem for Linux), genera el archivo:
     ```bash
     htpasswd -c C:\ruta\nginx-avanzado\conf\passwords\usuarios.htpasswd usuario1
     ```
     Se te pedirá la contraseña. El archivo se guardará con el hash apropiado.  
   - Si no la tienes en Windows, puedes crear el archivo dentro del contenedor (usando un contenedor temporal con Apache Tools, o con `openssl passwd`), o buscar alguna herramienta online de generador `.htpasswd`.

2. **Configurar la autenticación básica en Nginx**  
   Dentro de tu `server` o `location`, añade:
   ```nginx
   server {
       listen 80;
       server_name ejemplo.local;

       # Ruta de tu sitio
       root /usr/share/nginx/html/ejemplo;

       location /admin {
           auth_basic           "Area Restringida";
           auth_basic_user_file /etc/nginx/passwords/usuarios.htpasswd;
       }
   }
   ```
   - Monta la carpeta de contraseñas en el contenedor. Por ejemplo, si tu archivo local está en `C:\ruta\nginx-avanzado\conf\passwords\usuarios.htpasswd`, puedes montar `C:\ruta\nginx-avanzado\conf:/etc/nginx` y ubicarlo dentro de `/etc/nginx/passwords/usuarios.htpasswd`.

3. **Recarga Nginx y prueba**  
   - Visita `http://ejemplo.local:8081/admin`, te pedirá usuario y contraseña.  
   - Si todo está bien, podrás acceder al contenido de esa carpeta.

## Paso 6: Implementar HTTPS en local con certificados autofirmados o CA local

Cuando necesitas usar HTTPS en un entorno de **desarrollo** o **pruebas**, Let's Encrypt no funciona para dominios que no sean públicos. Dos caminos:

> **Nota**: recuerda que XAMPP incluye OpenSSL en su instalación. Para verlo, busca en la carpeta principal de XAMPP (por ejemplo, `C:\xampp`) y dentro de la subcarpeta de Apache (`apache\bin`). Allí debería aparecer un archivo llamado `openssl.exe` (o similar).

### Opción A: Certificado autofirmado

1. **Generar par de claves y certificado**  
   - Desde tu **host Windows** (con OpenSSL instalado) o dentro de un contenedor que tenga OpenSSL:
     ```bash
     openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
       -keyout localhost.key \
       -out localhost.crt
     ```
     Rellena el “Common Name” con `localhost` o `ejemplo.local`.

2. **Montar los certificados en el contenedor**  
   - Supón que guardas `localhost.crt` y `localhost.key` en `C:\ruta\nginx-avanzado\certs`.  
   - Asegúrate de montar esa carpeta en `/etc/nginx/certs`:
     ```bash
     docker run -d --name advanced-nginx \
       -p 443:443 \
       -v C:\ruta\nginx-avanzado\conf:/etc/nginx \
       -v C:\ruta\nginx-avanzado\html:/usr/share/nginx/html \
       -v C:\ruta\nginx-avanzado\logs:/var/log/nginx \
       -v C:\ruta\nginx-avanzado\certs:/etc/nginx/certs \
       nginx
     ```

3. **Configurar el bloque de servidor HTTPS**  
   En tu archivo `conf.d/ejemplo-ssl.conf` (o en `nginx.conf`):
   ```nginx
   server {
       listen 443 ssl;
       server_name ejemplo.local;

       ssl_certificate     /etc/nginx/certs/localhost.crt;
       ssl_certificate_key /etc/nginx/certs/localhost.key;

       root /usr/share/nginx/html/ejemplo;
       index index.html;
   }
   ```
   Recarga Nginx (`nginx -s reload`) y visita `https://ejemplo.local` (o `https://localhost`).  
   Tu navegador mostrará una **advertencia** porque es un certificado autofirmado.

### Opción B: Crear tu propia CA local y firmar certificados

1. **Generar la CA**  
   ```bash
   openssl genrsa -out myCA.key 2048
   openssl req -x509 -new -nodes -key myCA.key -sha256 -days 3650 -out myCA.crt
   ```
   Instala `myCA.crt` como “Autoridad de certificación raíz de confianza” en Windows.

2. **Crear CSR y firmarlo**  
   ```bash
   openssl genrsa -out ejemplo_local.key 2048
   openssl req -new -key ejemplo_local.key -out ejemplo_local.csr
   openssl x509 -req -in ejemplo_local.csr -CA myCA.crt -CAkey myCA.key \
       -CAcreateserial -out ejemplo_local.crt -days 365 -sha256
   ```
3. **Montar y configurar en Nginx**  
   - Mismo procedimiento: colocar `ejemplo_local.crt`, `ejemplo_local.key` y `myCA.crt` en `C:\ruta\nginx-avanzado\certs` (o donde desees).
   - En `server`:
     ```nginx
     listen 443 ssl;
     server_name ejemplo.local;

     ssl_certificate     /etc/nginx/certs/ejemplo_local.crt;
     ssl_certificate_key /etc/nginx/certs/ejemplo_local.key;
     ssl_trusted_certificate /etc/nginx/certs/myCA.crt;
     ```
   Como tu Windows ahora confía en la CA, **no** verás la advertencia de “sitio inseguro”.

## Paso 7: Obtener certificados Let’s Encrypt en Windows con Nginx (dominio público)

> **Nota**: **Solo aplica** si posees un dominio **público** en internet y tu _router/firewall_ está configurado para redirigir las peticiones externas a tu PC local.

1. **Sobre Let’s Encrypt y ACME**  
   Let’s Encrypt ofrece certificados gratuitos. El protocolo ACME (Automatic Certificate Management Environment) valida automáticamente la propiedad del dominio y emite/renueva certificados.

2. **Certbot y su soporte en Windows**  
   - El equipo de Certbot ha [discontinuado soporte para Windows](https://community.letsencrypt.org/t/certbot-discontinuing-windows-beta-support-in-2024/208101).  
   - Usa herramientas alternativas como [**win-acme**](https://www.win-acme.com/) o [Certify The Web](https://certifytheweb.com).

3. **win-acme** (ejemplo)  
   - Descarga `win-acme` y ejecútalo en **Windows** (no dentro del contenedor).  
   - El asistente te guiará para solicitar un certificado para `tudominio.com`:
     1. Seleccionas el tipo de validación (HTTP o DNS).
     2. Al usar HTTP, necesitarás que las peticiones a `http://tudominio.com/.well-known/acme-challenge/...` lleguen a tu Nginx local. Asegúrate de exponer el puerto 80 desde Docker a internet.

4. **Configura Nginx para usar el certificado emitido**  
   - win-acme genera los archivos `.pem` (por ejemplo, `cert.pem`, `chain.pem`, `privkey.pem`) en una ruta local en Windows (ej. `C:\win-acme\...`).
   - Monta esa carpeta con Docker o copia esos archivos a `C:\ruta\nginx-avanzado\certs`.  
   - Ajusta tu bloque `server`:
     ```nginx
     listen 443 ssl;
     server_name tudominio.com;

     ssl_certificate     /etc/nginx/certs/cert.pem;
     ssl_certificate_key /etc/nginx/certs/privkey.pem;
     ssl_trusted_certificate /etc/nginx/certs/chain.pem;
     ```
   - Recarga Nginx.  
   - Visita `https://tudominio.com` y verifica que el certificado sea **válido**.

5. **Renovación automática**  
   - Configura win-acme para que verifique y renueve cada cierto tiempo (típicamente 60 días).  
   - Asegúrate de reiniciar o recargar Nginx cuando se actualicen los certificados.

## Paso 8: Asegurar las comunicaciones y gestionar logs avanzados

### 1. Forzar HTTPS

En Nginx, puedes forzar redirección HTTP → HTTPS. Por ejemplo, define dos bloques `server`:

```nginx
# Bloque HTTP
server {
    listen 80;
    server_name tudominio.com;

    return 301 https://$host$request_uri;
}

# Bloque HTTPS
server {
    listen 443 ssl;
    server_name tudominio.com;

    ssl_certificate     /etc/nginx/certs/cert.pem;
    ssl_certificate_key /etc/nginx/certs/privkey.pem;

    # Sitio principal
    root /usr/share/nginx/html/mi-sitio;
    index index.html;
}
```

### 2. Cabeceras de seguridad

Al igual que en Apache, en Nginx puedes añadir cabeceras HSTS, XSS protection, etc. Ejemplo en tu bloque `server` o `location`:

```nginx
add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-Frame-Options "DENY" always;
add_header X-XSS-Protection "1; mode=block" always;
```

### 3. Deshabilitar protocolos antiguos

Para solo permitir TLS >= 1.2:

```nginx
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers   HIGH:!aNULL:!MD5;
```

### 4. Reinicia/recarga y verifica

Después de modificar tu archivo de configuración:

```bash
docker exec -it advanced-nginx nginx -s reload
```

Verifica en el navegador si funcionan las redirecciones y cabeceras de seguridad.  
O utiliza herramientas como [**SSL Labs**](https://www.ssllabs.com/ssltest/) (si tu sitio está accesible públicamente) para un análisis de tu configuración SSL.

## Paso 9: Centralizar y analizar los _logs_ de Nginx

En un entorno de contenedores, hay varias aproximaciones para gestionar _logs_:

1. **Logs al _host_**  
   Ya mapeaste `/var/log/nginx` a `C:\ruta\nginx-avanzado\logs`. Puedes simplemente usar un visor de logs local, como [LogViewPlus](https://www.logviewplus.com/), [glogg](https://glogg.bonnefon.org/), etc.

2. **Envía logs a una herramienta externa (ELK, Loki, etc.)**  
   - Puedes usar un contenedor adicional de Filebeat, Logstash, Fluentd, etc., que reenvíe los logs de `advanced-nginx` a Elasticsearch, Splunk, Graylog o la solución que prefieras.
   - Por ejemplo, con Docker Compose podrías tener:
     ```yaml
     services:
       advanced-nginx:
         image: nginx
         volumes:
           - ./conf:/etc/nginx
           - ./html:/usr/share/nginx/html
           - ./logs:/var/log/nginx
         ports:
           - "8081:80"

       logstash:
         image: logstash
         # ...
     ```
   - Y configuras Logstash para leer los logs montados y enviarlos a Elasticsearch.

3. **Monitorizar en tiempo real**  
   - Si deseas ver logs en vivo, ejecuta:
     ```bash
     docker logs -f advanced-nginx
     ```
   - Aunque Nginx a veces separa logs de error y acceso en distintos ficheros, con Docker todo se consolida en stdout/stderr a menos que configures lo contrario. Tenlo en cuenta si usas `docker logs`.
