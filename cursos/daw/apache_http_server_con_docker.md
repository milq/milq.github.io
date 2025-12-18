# Tutorial: Apache HTTP Server con Docker en Windows

En este tutorial aprenderás a desplegar, configurar y administrar Apache HTTP Server mediante contenedores Docker. Se cubren los fundamentos de ambas tecnologías de forma progresiva, desde la ejecución básica hasta la creación de imágenes personalizadas y orquestación con Docker Compose.

## **Paso 1: Verificación del entorno Docker**

Antes de trabajar con contenedores, es necesario confirmar que Docker está instalado y operativo.

### 1.1 Comprobar la instalación

Abre PowerShell y ejecuta:

```powershell
docker --version
```

Salida esperada:
```
Docker version 24.0.x, build xxxxxxx
```

Si el comando no es reconocido, Docker no está instalado o no está en el PATH del sistema.

### 1.2 Verificar el demonio Docker

El demonio (daemon) es el proceso en segundo plano que gestiona los contenedores. Comprueba su estado:

```powershell
docker info
```

Este comando muestra información detallada del sistema Docker: número de contenedores, imágenes almacenadas, driver de almacenamiento, versión del kernel, etc.

Si recibes el error `Cannot connect to the Docker daemon`, significa que Docker Desktop no está en ejecución. Inícialo desde el menú de Windows.

### 1.3 Ejecutar contenedor de prueba

Valida que Docker puede descargar imágenes y ejecutar contenedores:

```powershell
docker run hello-world
```

Este comando realiza las siguientes operaciones:
1. Busca la imagen `hello-world` localmente
2. Al no encontrarla, la descarga desde Docker Hub
3. Crea un contenedor a partir de la imagen
4. Ejecuta el contenedor, que imprime un mensaje de confirmación
5. El contenedor termina su ejecución

Si ves el mensaje `Hello from Docker!`, el entorno está correctamente configurado.

## **Paso 2: Fundamentos de Docker**

### 2.1 Arquitectura de Docker

Docker utiliza una arquitectura cliente-servidor:

```
┌─────────────────────────────────────────────────────────────┐
│                        HOST (Windows)                       │
│  ┌─────────────┐      ┌─────────────────────────────────┐   │
│  │   Cliente   │ ───► │         Docker Daemon           │   │
│  │   (CLI)     │      │  ┌───────────┐ ┌───────────┐    │   │
│  └─────────────┘      │  │ Container │ │ Container │    │   │
│                       │  └───────────┘ └───────────┘    │   │
│                       │         │              │        │   │
│                       │     ┌───┴──────────────┴───┐    │   │
│                       │     │       Images         │    │   │
│                       │     └──────────────────────┘    │   │
│                       └─────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Conceptos fundamentales

**Imagen (Image):** Plantilla de solo lectura que contiene el sistema de archivos y la configuración necesaria para ejecutar una aplicación. Las imágenes se construyen en capas, donde cada capa representa una instrucción del Dockerfile.

**Contenedor (Container):** Instancia ejecutable de una imagen. Es un proceso aislado que tiene su propio sistema de archivos, red y árbol de procesos. Los contenedores son efímeros por diseño: cuando se eliminan, se pierden todos los datos que no estén en volúmenes persistentes.

**Volumen (Volume):** Mecanismo para persistir datos generados por contenedores. Los volúmenes existen fuera del ciclo de vida del contenedor.

**Puerto (Port):** Los contenedores tienen su propia pila de red. Para acceder a servicios dentro del contenedor desde el host, es necesario mapear puertos.

### 2.3 Comandos esenciales

| Comando | Función |
|---------|---------|
| `docker pull <imagen>` | Descarga una imagen desde el registro |
| `docker images` | Lista imágenes locales |
| `docker run <imagen>` | Crea y ejecuta un contenedor |
| `docker ps` | Lista contenedores en ejecución |
| `docker ps -a` | Lista todos los contenedores |
| `docker stop <id\|nombre>` | Envía SIGTERM al contenedor |
| `docker start <id\|nombre>` | Inicia un contenedor detenido |
| `docker rm <id\|nombre>` | Elimina un contenedor |
| `docker rmi <imagen>` | Elimina una imagen |
| `docker logs <id\|nombre>` | Muestra stdout/stderr del contenedor |
| `docker exec <id\|nombre> <cmd>` | Ejecuta un comando en contenedor activo |

## **Paso 3: Apache HTTP Server - Conceptos**

### 3.1 Qué es Apache HTTP Server

Apache HTTP Server (httpd) es un servidor web de código abierto desarrollado por la Apache Software Foundation. Su función es:

1. Escuchar peticiones HTTP en un puerto (por defecto 80)
2. Interpretar la URL solicitada
3. Localizar el recurso en el sistema de archivos
4. Devolver el recurso al cliente con las cabeceras HTTP apropiadas

### 3.2 Arquitectura de Apache

```
┌────────────────────────────────────────────────────┐
│                   Apache httpd                     │
│  ┌──────────────────────────────────────────────┐  │
│  │              Módulos (DSO)                   │  │
│  │  mod_ssl │ mod_rewrite │ mod_proxy │ ...     │  │
│  └──────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────┐  │
│  │           MPM (Multi-Processing Module)      │  │
│  │      prefork │ worker │ event                │  │
│  └──────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────┐  │
│  │              Core httpd                      │  │
│  └──────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────┘
```

**MPM (Multi-Processing Module):** Define cómo Apache maneja las conexiones concurrentes:
- `prefork`: Un proceso por conexión (compatible con módulos no thread-safe)
- `worker`: Múltiples hilos por proceso
- `event`: Similar a worker pero optimizado para conexiones keep-alive

La imagen oficial de Docker usa `event` por defecto.

### 3.3 Estructura de directorios en la imagen httpd

```
/usr/local/apache2/
├── bin/                    # Binarios (httpd, apachectl)
├── conf/
│   ├── httpd.conf          # Configuración principal
│   ├── mime.types          # Tipos MIME
│   └── extra/              # Configuraciones adicionales
│       ├── httpd-ssl.conf
│       ├── httpd-vhosts.conf
│       └── ...
├── htdocs/                 # DocumentRoot (archivos web)
├── logs/                   # access_log, error_log
└── modules/                # Módulos compilados (.so)
```

## **Paso 4: Descargar la imagen de Apache**

### 4.1 Obtener la imagen oficial

```powershell
docker pull httpd:2.4
```

Salida:
```
2.4: Pulling from library/httpd
a2abf6c4d29d: Pull complete
dcc4698797c8: Pull complete
41c22baa66ec: Pull complete
67283bbdd4a0: Pull complete
d982c879c57e: Pull complete
Digest: sha256:a182ef2350699f04b8f8e736747104eb273e255e818cd55b6d7aa50a1490ed0c
Status: Downloaded newer image for httpd:2.4
docker.io/library/httpd:2.4
```

El tag `2.4` especifica la versión. Usar tags específicos es una buena práctica para garantizar reproducibilidad.

### 4.2 Verificar la descarga

```powershell
docker images httpd
```

Salida:
```
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
httpd        2.4       a182ef235069   2 weeks ago   148MB
```

### 4.3 Inspeccionar la imagen

Para ver metadatos de la imagen:

```powershell
docker inspect httpd:2.4
```

Información relevante que muestra este comando:
- `Config.ExposedPorts`: Puertos que el contenedor expone (80/tcp)
- `Config.Cmd`: Comando por defecto (`httpd-foreground`)
- `Config.WorkingDir`: Directorio de trabajo
- `Architecture`: Arquitectura de la imagen (amd64)

## **Paso 5: Ejecutar el primer contenedor Apache**

### 5.1 Comando básico

```powershell
docker run -d --name apache-basico -p 8080:80 httpd:2.4
```

Desglose de parámetros:

| Parámetro | Descripción |
|-----------|-------------|
| `run` | Crea un nuevo contenedor y lo ejecuta |
| `-d` | Modo detached (segundo plano). Sin este flag, la terminal queda adjunta al proceso |
| `--name apache-basico` | Asigna un nombre identificativo. Sin esto, Docker genera un nombre aleatorio |
| `-p 8080:80` | Mapeo de puertos `<host>:<container>`. Publica el puerto 80 del contenedor en el 8080 del host |
| `httpd:2.4` | Imagen y tag a utilizar |

### 5.2 Mapeo de puertos en detalle

```
        HOST (Windows)                    CONTAINER
    ┌─────────────────┐              ┌─────────────────┐
    │                 │              │                 │
    │  localhost:8080 │◄────────────►│  0.0.0.0:80     │
    │                 │   -p 8080:80 │                 │
    │   (interfaz de  │              │  (Apache httpd  │
    │    red del host)│              │   escuchando)   │
    └─────────────────┘              └─────────────────┘
```

El puerto 80 dentro del contenedor solo es accesible desde la red interna de Docker. El flag `-p` crea una regla de NAT que redirige el tráfico.

### 5.3 Verificar el contenedor

Listar contenedores activos:

```powershell
docker ps
```

Salida:
```
CONTAINER ID   IMAGE       COMMAND              CREATED          STATUS          PORTS                  NAMES
a1b2c3d4e5f6   httpd:2.4   "httpd-foreground"   10 seconds ago   Up 9 seconds    0.0.0.0:8080->80/tcp   apache-basico
```

Campos relevantes:
- `CONTAINER ID`: Identificador único (se puede usar de forma abreviada)
- `COMMAND`: Proceso principal del contenedor
- `STATUS`: Estado actual y tiempo de ejecución
- `PORTS`: Mapeo de puertos activo

### 5.4 Probar el servidor

Desde PowerShell:

```powershell
curl http://localhost:8080
```

O usando Invoke-WebRequest:

```powershell
(Invoke-WebRequest -Uri http://localhost:8080).Content
```

Salida esperada:
```html
<html><body><h1>It works!</h1></body></html>
```

También puedes abrir `http://localhost:8080` en un navegador.

## **Paso 6: Gestión del contenedor**

### 6.1 Ver logs del servidor

Los logs son fundamentales para diagnóstico. Apache escribe en dos logs:
- `access_log`: Registro de peticiones recibidas
- `error_log`: Errores y advertencias

En el contenedor Docker, ambos están redirigidos a stdout/stderr:

```powershell
docker logs apache-basico
```

Salida típica:
```
AH00558: httpd: Could not reliably determine the server's fully qualified domain name
[Sun Jan 14 10:23:45.678901 2024] [mpm_event:notice] [pid 1:tid 1] AH00489: Apache/2.4.58 (Unix) configured -- resuming normal operations
[Sun Jan 14 10:23:45.679012 2024] [core:notice] [pid 1:tid 1] AH00094: Command line: 'httpd -D FOREGROUND'
172.17.0.1 - - [14/Jan/2024:10:24:01 +0000] "GET / HTTP/1.1" 200 45
```

Para seguir los logs en tiempo real:

```powershell
docker logs -f apache-basico
```

Presiona `Ctrl+C` para salir del modo follow.

### 6.2 Acceder al shell del contenedor

Para ejecutar comandos dentro del contenedor:

```powershell
docker exec -it apache-basico bash
```

Parámetros:
- `-i`: Mantiene STDIN abierto (interactivo)
- `-t`: Asigna una pseudo-TTY

Una vez dentro del contenedor:

```bash
# Ver versión de Apache
httpd -v
# Salida: Server version: Apache/2.4.58 (Unix)

# Ver módulos compilados estáticamente
httpd -l

# Ver módulos cargados (estáticos y dinámicos)
httpd -M

# Ver configuración efectiva
httpd -S

# Verificar sintaxis de configuración
httpd -t

# Ver contenido del DocumentRoot
ls -la /usr/local/apache2/htdocs/

# Leer el archivo index.html por defecto
cat /usr/local/apache2/htdocs/index.html

# Salir del contenedor
exit
```

### 6.3 Ciclo de vida del contenedor

```
     docker run           docker stop          docker start
         │                    │                     │
         ▼                    ▼                     ▼
    ┌─────────┐          ┌─────────┐          ┌─────────┐
    │ Created │─────────►│ Running │─────────►│ Stopped │
    └─────────┘          └─────────┘          └─────────┘
                              │                     │
                              │     docker rm       │
                              ▼                     ▼
                         ┌─────────┐          ┌─────────┐
                         │ Removed │◄─────────│ Removed │
                         └─────────┘          └─────────┘
```

Comandos de control:

```powershell
# Detener el contenedor (envía SIGTERM, luego SIGKILL tras 10s)
docker stop apache-basico

# Verificar que está detenido
docker ps -a
# STATUS mostrará "Exited (0)"

# Iniciar el contenedor detenido
docker start apache-basico

# Reiniciar (stop + start)
docker restart apache-basico

# Eliminar contenedor (debe estar detenido)
docker stop apache-basico
docker rm apache-basico

# Eliminar contenedor forzadamente (aunque esté corriendo)
docker rm -f apache-basico
```

## **Paso 7: Montar volúmenes - Servir contenido propio**

Los volúmenes permiten que los datos persistan fuera del contenedor y facilitan el desarrollo al reflejar cambios en tiempo real.

### 7.1 Crear estructura de proyecto

```powershell
# Crear directorio del proyecto
New-Item -ItemType Directory -Path C:\apache-proyecto -Force
Set-Location C:\apache-proyecto

# Crear subdirectorios
New-Item -ItemType Directory -Path .\htdocs -Force
```

### 7.2 Crear archivo HTML

Crea el archivo `C:\apache-proyecto\htdocs\index.html`:

```powershell
@"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apache en Docker</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            color: #e4e4e4;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 40px;
            max-width: 600px;
            backdrop-filter: blur(10px);
        }
        h1 { color: #00d9ff; margin-bottom: 20px; }
        h2 { color: #ff6b6b; margin: 25px 0 15px 0; font-size: 1.2em; }
        p { line-height: 1.7; margin-bottom: 15px; }
        code {
            background: rgba(0,217,255,0.1);
            padding: 2px 8px;
            border-radius: 4px;
            font-family: 'Consolas', monospace;
        }
        ul { margin-left: 20px; }
        li { margin: 8px 0; }
        .status {
            background: #00d97e;
            color: #000;
            padding: 10px 20px;
            border-radius: 6px;
            text-align: center;
            font-weight: bold;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="status">SERVIDOR OPERATIVO</div>
        <h1>Apache HTTP Server en Docker</h1>
        <p>Este contenido se sirve desde un volumen montado en el contenedor.</p>
        
        <h2>Configuracion actual</h2>
        <ul>
            <li>Servidor: Apache 2.4</li>
            <li>Puerto host: 8080</li>
            <li>Puerto contenedor: 80</li>
            <li>DocumentRoot: /usr/local/apache2/htdocs</li>
        </ul>
        
        <h2>Volumen montado</h2>
        <p>Ruta Windows: <code>C:\apache-proyecto\htdocs</code></p>
        <p>Ruta contenedor: <code>/usr/local/apache2/htdocs</code></p>
        
        <h2>Prueba de actualizacion</h2>
        <p>Modifica este archivo y recarga el navegador para ver los cambios en tiempo real.</p>
    </div>
</body>
</html>
"@ | Out-File -FilePath C:\apache-proyecto\htdocs\index.html -Encoding UTF8
```

### 7.3 Ejecutar contenedor con volumen

```powershell
docker run -d `
    --name apache-volumen `
    -p 8080:80 `
    -v C:\apache-proyecto\htdocs:/usr/local/apache2/htdocs:ro `
    httpd:2.4
```

Parámetros del volumen `-v`:

| Componente | Descripción |
|------------|-------------|
| `C:\apache-proyecto\htdocs` | Ruta absoluta en el host Windows |
| `/usr/local/apache2/htdocs` | Punto de montaje dentro del contenedor |
| `:ro` | Modo solo lectura (read-only). Opcional pero recomendado para producción |

### 7.4 Tipos de montaje en Docker

```
┌─────────────────────────────────────────────────────────────┐
│                    Tipos de Montaje                         │
├─────────────────┬───────────────────────────────────────────┤
│ Bind Mount      │ Monta un directorio del host              │
│ (-v /host:/cont)│ Los cambios son bidireccionales           │
├─────────────────┼───────────────────────────────────────────┤
│ Named Volume    │ Docker gestiona la ubicación              │
│ (-v nombre:/c)  │ Persistencia gestionada por Docker        │
├─────────────────┼───────────────────────────────────────────┤
│ tmpfs Mount     │ Solo en memoria (Linux)                   │
│ (--tmpfs /path) │ No persiste tras reinicio                 │
└─────────────────┴───────────────────────────────────────────┘
```

### 7.5 Verificar el montaje

```powershell
# Ver los montajes del contenedor
docker inspect apache-volumen --format '{{json .Mounts}}' | ConvertFrom-Json | Format-List
```

Accede a `http://localhost:8080` para ver la página.

### 7.6 Probar actualización en tiempo real

1. Edita `C:\apache-proyecto\htdocs\index.html`
2. Cambia el texto "SERVIDOR OPERATIVO" por "SERVIDOR MODIFICADO"
3. Guarda el archivo
4. Recarga el navegador (F5)

El cambio debe reflejarse inmediatamente sin reiniciar el contenedor.

## **Paso 8: Configuración personalizada de Apache**

### 8.1 Estructura del proyecto

```powershell
# Crear estructura
New-Item -ItemType Directory -Path C:\apache-custom -Force
New-Item -ItemType Directory -Path C:\apache-custom\htdocs -Force
New-Item -ItemType Directory -Path C:\apache-custom\conf -Force
```

### 8.2 Extraer configuración por defecto

Primero, extrae el archivo de configuración original para usarlo como base:

```powershell
# Crear contenedor temporal
docker run -d --name temp-apache httpd:2.4

# Copiar archivo de configuración al host
docker cp temp-apache:/usr/local/apache2/conf/httpd.conf C:\apache-custom\conf\httpd.conf

# Eliminar contenedor temporal
docker rm -f temp-apache
```

### 8.3 Crear configuración personalizada

Crea el archivo `C:\apache-custom\conf\httpd.conf`:

```powershell
@"
# ==============================================================================
# CONFIGURACION APACHE HTTP SERVER - ENTORNO DOCKER
# ==============================================================================

# Directorio raiz de Apache
ServerRoot "/usr/local/apache2"

# Puerto de escucha
Listen 80

# ------------------------------------------------------------------------------
# MODULOS
# ------------------------------------------------------------------------------
LoadModule mpm_event_module modules/mod_mpm_event.so
LoadModule authn_file_module modules/mod_authn_file.so
LoadModule authn_core_module modules/mod_authn_core.so
LoadModule authz_host_module modules/mod_authz_host.so
LoadModule authz_groupfile_module modules/mod_authz_groupfile.so
LoadModule authz_user_module modules/mod_authz_user.so
LoadModule authz_core_module modules/mod_authz_core.so
LoadModule access_compat_module modules/mod_access_compat.so
LoadModule auth_basic_module modules/mod_auth_basic.so
LoadModule reqtimeout_module modules/mod_reqtimeout.so
LoadModule filter_module modules/mod_filter.so
LoadModule mime_module modules/mod_mime.so
LoadModule log_config_module modules/mod_log_config.so
LoadModule env_module modules/mod_env.so
LoadModule headers_module modules/mod_headers.so
LoadModule setenvif_module modules/mod_setenvif.so
LoadModule version_module modules/mod_version.so
LoadModule unixd_module modules/mod_unixd.so
LoadModule status_module modules/mod_status.so
LoadModule autoindex_module modules/mod_autoindex.so
LoadModule dir_module modules/mod_dir.so
LoadModule alias_module modules/mod_alias.so
LoadModule rewrite_module modules/mod_rewrite.so

# ------------------------------------------------------------------------------
# CONFIGURACION DEL SERVIDOR
# ------------------------------------------------------------------------------

# Usuario y grupo bajo el que corre Apache
<IfModule unixd_module>
    User www-data
    Group www-data
</IfModule>

# Nombre del servidor
ServerName localhost:80

# Email del administrador
ServerAdmin webmaster@localhost

# Deshabilitar firma del servidor en errores
ServerSignature Off
ServerTokens Prod

# ------------------------------------------------------------------------------
# DIRECTORIO DE DOCUMENTOS
# ------------------------------------------------------------------------------

DocumentRoot "/usr/local/apache2/htdocs"

<Directory "/usr/local/apache2/htdocs">
    # Opciones del directorio
    Options Indexes FollowSymLinks
    
    # Permitir .htaccess
    AllowOverride All
    
    # Control de acceso
    Require all granted
</Directory>

# Archivos de indice por defecto
<IfModule dir_module>
    DirectoryIndex index.html index.htm
</IfModule>

# Denegar acceso a archivos .htaccess
<Files ".ht*">
    Require all denied
</Files>

# ------------------------------------------------------------------------------
# LOGS
# ------------------------------------------------------------------------------

# Nivel de log: debug, info, notice, warn, error, crit, alert, emerg
LogLevel warn

# Formato de logs
<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common
    
    # En Docker, redirigir a stdout/stderr
    CustomLog /proc/self/fd/1 combined
</IfModule>

ErrorLog /proc/self/fd/2

# ------------------------------------------------------------------------------
# TIPOS MIME
# ------------------------------------------------------------------------------

<IfModule mime_module>
    TypesConfig conf/mime.types
    
    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz
    AddType text/html .shtml
    AddType application/x-httpd-php .php
    
    # Charset por defecto
    AddDefaultCharset UTF-8
</IfModule>

# ------------------------------------------------------------------------------
# SEGURIDAD
# ------------------------------------------------------------------------------

# Headers de seguridad
<IfModule headers_module>
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-XSS-Protection "1; mode=block"
</IfModule>

# Timeout de conexiones
Timeout 60
KeepAlive On
MaxKeepAliveRequests 100
KeepAliveTimeout 5

# ------------------------------------------------------------------------------
# MPM EVENT (Multi-Processing Module)
# ------------------------------------------------------------------------------

<IfModule mpm_event_module>
    StartServers             2
    MinSpareThreads         25
    MaxSpareThreads         75
    ThreadLimit             64
    ThreadsPerChild         25
    MaxRequestWorkers      150
    MaxConnectionsPerChild   0
</IfModule>

# ------------------------------------------------------------------------------
# PAGINA DE ESTADO (para monitoreo)
# ------------------------------------------------------------------------------

<IfModule status_module>
    <Location "/server-status">
        SetHandler server-status
        Require ip 172.17.0.0/16
        Require ip 127.0.0.1
    </Location>
</IfModule>
"@ | Out-File -FilePath C:\apache-custom\conf\httpd.conf -Encoding ASCII
```

### 8.4 Crear página HTML

```powershell
@"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Configuracion Personalizada</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #0f0f23;
            color: #ccc;
            padding: 40px;
            line-height: 1.6;
        }
        .container { max-width: 800px; margin: 0 auto; }
        h1 { color: #00ff41; border-bottom: 2px solid #00ff41; padding-bottom: 10px; }
        h2 { color: #ffcc00; margin-top: 30px; }
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin: 20px 0;
            background: #1a1a2e;
        }
        th, td { 
            padding: 12px; 
            text-align: left; 
            border: 1px solid #333;
        }
        th { background: #16213e; color: #00d9ff; }
        code { 
            background: #1a1a2e; 
            padding: 2px 6px; 
            border-radius: 3px;
            color: #00ff41;
        }
        .success { color: #00ff41; }
        .config-item { color: #ff6b6b; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Apache - Configuracion Personalizada</h1>
        <p class="success">El servidor esta usando el archivo httpd.conf personalizado.</p>
        
        <h2>Directivas configuradas</h2>
        <table>
            <tr><th>Directiva</th><th>Valor</th></tr>
            <tr><td>ServerName</td><td><code>localhost:80</code></td></tr>
            <tr><td>DocumentRoot</td><td><code>/usr/local/apache2/htdocs</code></td></tr>
            <tr><td>LogLevel</td><td><code>warn</code></td></tr>
            <tr><td>KeepAlive</td><td><code>On</code></td></tr>
            <tr><td>Timeout</td><td><code>60</code></td></tr>
            <tr><td>MPM</td><td><code>event</code></td></tr>
        </table>
        
        <h2>Modulos cargados</h2>
        <p>mod_rewrite, mod_headers, mod_status, mod_dir, mod_mime, mod_log_config</p>
        
        <h2>Headers de seguridad</h2>
        <table>
            <tr><th>Header</th><th>Valor</th></tr>
            <tr><td>X-Content-Type-Options</td><td>nosniff</td></tr>
            <tr><td>X-Frame-Options</td><td>SAMEORIGIN</td></tr>
            <tr><td>X-XSS-Protection</td><td>1; mode=block</td></tr>
        </table>
    </div>
</body>
</html>
"@ | Out-File -FilePath C:\apache-custom\htdocs\index.html -Encoding UTF8
```

### 8.5 Ejecutar con configuración personalizada

```powershell
docker run -d `
    --name apache-custom `
    -p 8080:80 `
    -v C:\apache-custom\htdocs:/usr/local/apache2/htdocs `
    -v C:\apache-custom\conf\httpd.conf:/usr/local/apache2/conf/httpd.conf:ro `
    httpd:2.4
```

### 8.6 Verificar la configuración

```powershell
# Verificar que el contenedor está corriendo
docker ps

# Verificar sintaxis de configuración dentro del contenedor
docker exec apache-custom httpd -t
# Salida esperada: Syntax OK

# Ver configuración de virtual hosts
docker exec apache-custom httpd -S
```

Verificar headers de seguridad:

```powershell
curl -I http://localhost:8080
```

Salida esperada (parcial):
```
HTTP/1.1 200 OK
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
```

## **Paso 9: Múltiples sitios web (Virtual Hosts)**

Apache puede servir múltiples sitios web desde un mismo servidor mediante Virtual Hosts.

### 9.1 Tipos de Virtual Hosts

| Tipo | Descripción | Uso |
|------|-------------|-----|
| Name-based | Diferencia por nombre de dominio | Múltiples dominios, una IP |
| IP-based | Diferencia por dirección IP | Una IP por sitio |
| Port-based | Diferencia por puerto | Desarrollo local |

En Docker, usaremos Port-based para simplicidad.

### 9.2 Crear estructura

```powershell
# Estructura base
New-Item -ItemType Directory -Path C:\multi-sitios -Force
New-Item -ItemType Directory -Path C:\multi-sitios\sitio1 -Force
New-Item -ItemType Directory -Path C:\multi-sitios\sitio2 -Force
New-Item -ItemType Directory -Path C:\multi-sitios\sitio3 -Force
```

### 9.3 Crear contenido para cada sitio

Sitio 1:
```powershell
@"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sitio 1 - Desarrollo</title>
    <style>
        body { 
            margin: 0; 
            min-height: 100vh; 
            display: flex; 
            justify-content: center; 
            align-items: center;
            background: #2980b9;
            font-family: Arial, sans-serif;
        }
        .card {
            background: white;
            padding: 60px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
        }
        h1 { color: #2980b9; margin: 0 0 10px 0; font-size: 3em; }
        p { color: #666; margin: 0; }
        .port { 
            background: #2980b9; 
            color: white; 
            padding: 5px 15px; 
            border-radius: 20px;
            display: inline-block;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>SITIO 1</h1>
        <p>Entorno de Desarrollo</p>
        <span class="port">Puerto 8081</span>
    </div>
</body>
</html>
"@ | Out-File -FilePath C:\multi-sitios\sitio1\index.html -Encoding UTF8
```

Sitio 2:
```powershell
@"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sitio 2 - Staging</title>
    <style>
        body { 
            margin: 0; 
            min-height: 100vh; 
            display: flex; 
            justify-content: center; 
            align-items: center;
            background: #27ae60;
            font-family: Arial, sans-serif;
        }
        .card {
            background: white;
            padding: 60px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
        }
        h1 { color: #27ae60; margin: 0 0 10px 0; font-size: 3em; }
        p { color: #666; margin: 0; }
        .port { 
            background: #27ae60; 
            color: white; 
            padding: 5px 15px; 
            border-radius: 20px;
            display: inline-block;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>SITIO 2</h1>
        <p>Entorno de Staging</p>
        <span class="port">Puerto 8082</span>
    </div>
</body>
</html>
"@ | Out-File -FilePath C:\multi-sitios\sitio2\index.html -Encoding UTF8
```

Sitio 3:
```powershell
@"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sitio 3 - Produccion</title>
    <style>
        body { 
            margin: 0; 
            min-height: 100vh; 
            display: flex; 
            justify-content: center; 
            align-items: center;
            background: #c0392b;
            font-family: Arial, sans-serif;
        }
        .card {
            background: white;
            padding: 60px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
        }
        h1 { color: #c0392b; margin: 0 0 10px 0; font-size: 3em; }
        p { color: #666; margin: 0; }
        .port { 
            background: #c0392b; 
            color: white; 
            padding: 5px 15px; 
            border-radius: 20px;
            display: inline-block;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>SITIO 3</h1>
        <p>Entorno de Produccion</p>
        <span class="port">Puerto 8083</span>
    </div>
</body>
</html>
"@ | Out-File -FilePath C:\multi-sitios\sitio3\index.html -Encoding UTF8
```

### 9.4 Ejecutar los tres contenedores

```powershell
# Detener contenedores previos si existen
docker rm -f apache-basico apache-volumen apache-custom 2>$null

# Sitio 1 - Puerto 8081
docker run -d `
    --name sitio1 `
    -p 8081:80 `
    -v C:\multi-sitios\sitio1:/usr/local/apache2/htdocs:ro `
    httpd:2.4

# Sitio 2 - Puerto 8082
docker run -d `
    --name sitio2 `
    -p 8082:80 `
    -v C:\multi-sitios\sitio2:/usr/local/apache2/htdocs:ro `
    httpd:2.4

# Sitio 3 - Puerto 8083
docker run -d `
    --name sitio3 `
    -p 8083:80 `
    -v C:\multi-sitios\sitio3:/usr/local/apache2/htdocs:ro `
    httpd:2.4
```

### 9.5 Verificar despliegue

```powershell
# Listar todos los contenedores
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

Salida:
```
NAMES    STATUS         PORTS
sitio3   Up 2 seconds   0.0.0.0:8083->80/tcp
sitio2   Up 3 seconds   0.0.0.0:8082->80/tcp
sitio1   Up 5 seconds   0.0.0.0:8081->80/tcp
```

Probar cada sitio:
- http://localhost:8081 (azul)
- http://localhost:8082 (verde)
- http://localhost:8083 (rojo)

### 9.6 Monitorear recursos

```powershell
docker stats --no-stream
```

Muestra CPU, memoria y I/O de cada contenedor.

## **Paso 10: Construcción de imágenes con Dockerfile**

Un Dockerfile define los pasos para construir una imagen personalizada.

### 10.1 Anatomía de un Dockerfile

```dockerfile
# Sintaxis de Dockerfile
# Cada instrucción crea una capa en la imagen

FROM <imagen_base>          # Imagen base (obligatorio, primera instrucción)
LABEL <key>=<value>         # Metadatos de la imagen
ENV <variable>=<valor>      # Variables de entorno
WORKDIR <ruta>              # Establece directorio de trabajo
COPY <origen> <destino>     # Copia archivos del host a la imagen
ADD <origen> <destino>      # Similar a COPY, pero puede descomprimir y usar URLs
RUN <comando>               # Ejecuta comando durante la construcción
EXPOSE <puerto>             # Documenta puertos que el contenedor expone
VOLUME <ruta>               # Crea punto de montaje
USER <usuario>              # Usuario para ejecutar comandos siguientes
CMD ["ejecutable","param"]  # Comando por defecto al iniciar contenedor
ENTRYPOINT ["ejecutable"]   # Punto de entrada del contenedor
```

### 10.2 Crear proyecto

```powershell
New-Item -ItemType Directory -Path C:\docker-apache-image -Force
Set-Location C:\docker-apache-image
New-Item -ItemType Directory -Path .\src -Force
New-Item -ItemType Directory -Path .\conf -Force
```

### 10.3 Crear el Dockerfile

```powershell
@"
# ==============================================================================
# Dockerfile para Apache HTTP Server personalizado
# ==============================================================================

# Imagen base oficial de Apache
FROM httpd:2.4-alpine

# Metadatos
LABEL maintainer="estudiante@ejemplo.com"
LABEL version="1.0"
LABEL description="Imagen Apache personalizada para entorno educativo"

# Variables de entorno
ENV APACHE_LOG_DIR=/usr/local/apache2/logs
ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data

# Instalar herramientas adicionales (curl para healthcheck)
RUN apk add --no-cache curl

# Copiar configuración personalizada
COPY conf/httpd.conf /usr/local/apache2/conf/httpd.conf

# Copiar contenido web
COPY src/ /usr/local/apache2/htdocs/

# Establecer permisos correctos
RUN chown -R www-data:www-data /usr/local/apache2/htdocs && \
    chmod -R 755 /usr/local/apache2/htdocs

# Documentar puerto expuesto
EXPOSE 80

# Healthcheck para verificar estado del servidor
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Comando por defecto (heredado de imagen base)
CMD ["httpd-foreground"]
"@ | Out-File -FilePath C:\docker-apache-image\Dockerfile -Encoding ASCII
```

### 10.4 Crear configuración

```powershell
@"
ServerRoot "/usr/local/apache2"
Listen 80

LoadModule mpm_event_module modules/mod_mpm_event.so
LoadModule authn_core_module modules/mod_authn_core.so
LoadModule authz_core_module modules/mod_authz_core.so
LoadModule dir_module modules/mod_dir.so
LoadModule mime_module modules/mod_mime.so
LoadModule log_config_module modules/mod_log_config.so
LoadModule unixd_module modules/mod_unixd.so
LoadModule headers_module modules/mod_headers.so
LoadModule setenvif_module modules/mod_setenvif.so

<IfModule unixd_module>
    User www-data
    Group www-data
</IfModule>

ServerName localhost:80
ServerSignature Off
ServerTokens Prod

DocumentRoot "/usr/local/apache2/htdocs"

<Directory "/usr/local/apache2/htdocs">
    Options -Indexes +FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>

<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>

<Files ".ht*">
    Require all denied
</Files>

ErrorLog /proc/self/fd/2
LogLevel warn

<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b" common
    CustomLog /proc/self/fd/1 common
</IfModule>

<IfModule mime_module>
    TypesConfig conf/mime.types
    AddDefaultCharset UTF-8
</IfModule>

<IfModule headers_module>
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "DENY"
</IfModule>
"@ | Out-File -FilePath C:\docker-apache-image\conf\httpd.conf -Encoding ASCII
```

### 10.5 Crear contenido web

```powershell
@"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Imagen Docker Personalizada</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #0c0c0c 0%, #1a1a2e 50%, #16213e 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #fff;
        }
        .container {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 16px;
            padding: 50px;
            max-width: 700px;
            text-align: center;
        }
        .logo {
            font-size: 5em;
            margin-bottom: 20px;
        }
        h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            background: linear-gradient(90deg, #00d4ff, #00ff88);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .subtitle {
            color: #888;
            font-size: 1.1em;
            margin-bottom: 40px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            text-align: left;
        }
        .info-card {
            background: rgba(0,212,255,0.05);
            border: 1px solid rgba(0,212,255,0.2);
            border-radius: 10px;
            padding: 20px;
        }
        .info-card h3 {
            color: #00d4ff;
            font-size: 0.9em;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .info-card p {
            color: #ccc;
            font-family: 'Consolas', monospace;
        }
        .badge {
            display: inline-block;
            background: linear-gradient(90deg, #00d4ff, #00ff88);
            color: #000;
            padding: 8px 20px;
            border-radius: 20px;
            font-weight: bold;
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">&#128051;</div>
        <h1>Imagen Docker Custom</h1>
        <p class="subtitle">Apache HTTP Server construido desde Dockerfile</p>
        
        <div class="info-grid">
            <div class="info-card">
                <h3>Base Image</h3>
                <p>httpd:2.4-alpine</p>
            </div>
            <div class="info-card">
                <h3>Sistema</h3>
                <p>Alpine Linux</p>
            </div>
            <div class="info-card">
                <h3>Puerto</h3>
                <p>80/tcp</p>
            </div>
            <div class="info-card">
                <h3>Healthcheck</h3>
                <p>Habilitado</p>
            </div>
        </div>
        
        <span class="badge">BUILD EXITOSO</span>
    </div>
</body>
</html>
"@ | Out-File -FilePath C:\docker-apache-image\src\index.html -Encoding UTF8
```

### 10.6 Construir la imagen

```powershell
Set-Location C:\docker-apache-image

docker build -t mi-apache:1.0 .
```

Explicación del proceso de build:
```
Sending build context to Docker daemon  5.632kB    # Envía archivos al daemon
Step 1/10 : FROM httpd:2.4-alpine                  # Descarga imagen base
Step 2/10 : LABEL maintainer="..."                 # Añade metadatos
Step 3/10 : ENV APACHE_LOG_DIR=...                 # Define variables
...
Successfully built a1b2c3d4e5f6
Successfully tagged mi-apache:1.0
```

### 10.7 Verificar la imagen

```powershell
# Listar imágenes
docker images mi-apache

# Ver historial de capas
docker history mi-apache:1.0

# Inspeccionar imagen
docker inspect mi-apache:1.0 --format '{{json .Config.Labels}}' | ConvertFrom-Json
```

### 10.8 Ejecutar la imagen personalizada

```powershell
docker run -d --name apache-custom-image -p 8080:80 mi-apache:1.0
```

### 10.9 Verificar healthcheck

```powershell
# Ver estado del healthcheck
docker inspect apache-custom-image --format '{{json .State.Health}}' | ConvertFrom-Json
```

Accede a http://localhost:8080 para ver el resultado.

## **Paso 11: Docker Compose para orquestación**

Docker Compose permite definir y ejecutar aplicaciones multi-contenedor mediante un archivo YAML.

### 11.1 Estructura del archivo docker-compose.yml

```yaml
version: "3.8"              # Versión del formato

services:                   # Definición de servicios (contenedores)
  nombre_servicio:
    image: imagen:tag       # Imagen a usar
    build: ./ruta           # O construir desde Dockerfile
    container_name: nombre  # Nombre del contenedor
    ports:                  # Mapeo de puertos
      - "host:container"
    volumes:                # Volúmenes
      - ./local:/container
    environment:            # Variables de entorno
      - VAR=valor
    networks:               # Redes
      - nombre_red
    depends_on:             # Dependencias
      - otro_servicio
    restart: unless-stopped # Política de reinicio

networks:                   # Definición de redes
  nombre_red:
    driver: bridge

volumes:                    # Definición de volúmenes nombrados
  nombre_volumen:
```

### 11.2 Crear proyecto

```powershell
New-Item -ItemType Directory -Path C:\compose-proyecto -Force
Set-Location C:\compose-proyecto
New-Item -ItemType Directory -Path .\web-principal -Force
New-Item -ItemType Directory -Path .\web-api -Force
New-Item -ItemType Directory -Path .\web-docs -Force
```

### 11.3 Crear docker-compose.yml

```powershell
@"
version: '3.8'

services:
  # Sitio web principal
  web:
    image: httpd:2.4
    container_name: compose-web-principal
    ports:
      - "8080:80"
    volumes:
      - ./web-principal:/usr/local/apache2/htdocs:ro
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 10s

  # API (simulada con HTML estático)
  api:
    image: httpd:2.4
    container_name: compose-web-api
    ports:
      - "8081:80"
    volumes:
      - ./web-api:/usr/local/apache2/htdocs:ro
    restart: unless-stopped
    depends_on:
      - web

  # Documentación
  docs:
    image: httpd:2.4
    container_name: compose-web-docs
    ports:
      - "8082:80"
    volumes:
      - ./web-docs:/usr/local/apache2/htdocs:ro
    restart: unless-stopped
    depends_on:
      - web
"@ | Out-File -FilePath C:\compose-proyecto\docker-compose.yml -Encoding ASCII
```

### 11.4 Crear contenido de cada servicio

Web Principal:
```powershell
@"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Portal Principal</title>
    <style>
        body { 
            font-family: 'Segoe UI', sans-serif; 
            background: #1a1a2e; 
            color: #eee; 
            margin: 0;
            padding: 40px;
        }
        .header { 
            background: linear-gradient(90deg, #e94560, #0f3460);
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        h1 { margin: 0; }
        .services {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }
        .service {
            background: #16213e;
            padding: 25px;
            border-radius: 10px;
            border-left: 4px solid #e94560;
        }
        .service h3 { color: #e94560; margin-top: 0; }
        a { color: #00d9ff; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Docker Compose - Portal Principal</h1>
        <p>Orquestacion de multiples contenedores Apache</p>
    </div>
    
    <div class="services">
        <div class="service">
            <h3>Web Principal</h3>
            <p>Puerto: 8080</p>
            <p>Estado: Activo</p>
            <a href="http://localhost:8080">Acceder</a>
        </div>
        <div class="service">
            <h3>API Service</h3>
            <p>Puerto: 8081</p>
            <p>Estado: Activo</p>
            <a href="http://localhost:8081">Acceder</a>
        </div>
        <div class="service">
            <h3>Documentacion</h3>
            <p>Puerto: 8082</p>
            <p>Estado: Activo</p>
            <a href="http://localhost:8082">Acceder</a>
        </div>
        <div class="service">
            <h3>Gestion</h3>
            <p>docker compose ps</p>
            <p>docker compose logs</p>
        </div>
    </div>
</body>
</html>
"@ | Out-File -FilePath C:\compose-proyecto\web-principal\index.html -Encoding UTF8
```

API:
```powershell
@"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>API Service</title>
    <style>
        body { 
            font-family: monospace; 
            background: #0d1117; 
            color: #c9d1d9; 
            padding: 40px;
        }
        pre {
            background: #161b22;
            padding: 20px;
            border-radius: 6px;
            border: 1px solid #30363d;
            overflow-x: auto;
        }
        .endpoint { color: #58a6ff; }
        .method { color: #7ee787; }
        .desc { color: #8b949e; }
    </style>
</head>
<body>
    <h1>API Service - Puerto 8081</h1>
    <p>Simulacion de endpoints API</p>
    
    <h2>Endpoints disponibles</h2>
    <pre>
<span class="method">GET</span>  <span class="endpoint">/api/users</span>      <span class="desc"># Lista usuarios</span>
<span class="method">GET</span>  <span class="endpoint">/api/users/:id</span>  <span class="desc"># Obtiene usuario</span>
<span class="method">POST</span> <span class="endpoint">/api/users</span>      <span class="desc"># Crea usuario</span>
<span class="method">PUT</span>  <span class="endpoint">/api/users/:id</span>  <span class="desc"># Actualiza usuario</span>
<span class="method">DEL</span>  <span class="endpoint">/api/users/:id</span>  <span class="desc"># Elimina usuario</span>
    </pre>
    
    <h2>Respuesta de ejemplo</h2>
    <pre>
{
    "status": "success",
    "service": "api",
    "port": 8081,
    "timestamp": "2024-01-14T10:30:00Z"
}
    </pre>
</body>
</html>
"@ | Out-File -FilePath C:\compose-proyecto\web-api\index.html -Encoding UTF8
```

Documentación:
```powershell
@"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Documentacion</title>
    <style>
        body { 
            font-family: 'Segoe UI', sans-serif; 
            background: #fff; 
            color: #333; 
            max-width: 800px;
            margin: 0 auto;
            padding: 40px;
            line-height: 1.8;
        }
        h1 { border-bottom: 3px solid #0066cc; padding-bottom: 10px; }
        h2 { color: #0066cc; margin-top: 40px; }
        code {
            background: #f4f4f4;
            padding: 2px 8px;
            border-radius: 4px;
            font-family: Consolas, monospace;
        }
        pre {
            background: #282c34;
            color: #abb2bf;
            padding: 20px;
            border-radius: 8px;
            overflow-x: auto;
        }
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin: 20px 0;
        }
        th, td { 
            border: 1px solid #ddd; 
            padding: 12px; 
            text-align: left;
        }
        th { background: #0066cc; color: white; }
    </style>
</head>
<body>
    <h1>Documentacion del Proyecto</h1>
    <p>Servicio de documentacion - Puerto 8082</p>
    
    <h2>Arquitectura</h2>
    <table>
        <tr><th>Servicio</th><th>Puerto</th><th>Funcion</th></tr>
        <tr><td>web</td><td>8080</td><td>Portal principal</td></tr>
        <tr><td>api</td><td>8081</td><td>Servicio API</td></tr>
        <tr><td>docs</td><td>8082</td><td>Documentacion</td></tr>
    </table>
    
    <h2>Comandos Docker Compose</h2>
    <pre>
# Iniciar servicios
docker compose up -d

# Ver estado
docker compose ps

# Ver logs
docker compose logs -f

# Detener servicios
docker compose down

# Reconstruir
docker compose up -d --build
    </pre>
    
    <h2>Estructura de archivos</h2>
    <pre>
compose-proyecto/
├── docker-compose.yml
├── web-principal/
│   └── index.html
├── web-api/
│   └── index.html
└── web-docs/
    └── index.html
    </pre>
</body>
</html>
"@ | Out-File -FilePath C:\compose-proyecto\web-docs\index.html -Encoding UTF8
```

### 11.5 Comandos de Docker Compose

```powershell
Set-Location C:\compose-proyecto

# Iniciar todos los servicios
docker compose up -d

# Ver estado de los servicios
docker compose ps

# Ver logs de todos los servicios
docker compose logs

# Ver logs de un servicio específico
docker compose logs web

# Seguir logs en tiempo real
docker compose logs -f

# Detener servicios sin eliminarlos
docker compose stop

# Iniciar servicios detenidos
docker compose start

# Reiniciar servicios
docker compose restart

# Detener y eliminar contenedores, redes
docker compose down

# Eliminar también volúmenes
docker compose down -v
```

### 11.6 Verificar despliegue

```powershell
docker compose ps
```

Salida esperada:
```
NAME                    IMAGE       COMMAND              SERVICE   CREATED         STATUS                   PORTS
compose-web-api         httpd:2.4   "httpd-foreground"   api       5 seconds ago   Up 4 seconds             0.0.0.0:8081->80/tcp
compose-web-docs        httpd:2.4   "httpd-foreground"   docs      5 seconds ago   Up 4 seconds             0.0.0.0:8082->80/tcp
compose-web-principal   httpd:2.4   "httpd-foreground"   web       5 seconds ago   Up 4 seconds (healthy)   0.0.0.0:8080->80/tcp
```

Acceder a:
- http://localhost:8080 (Portal principal)
- http://localhost:8081 (API)
- http://localhost:8082 (Documentación)

## **Paso 12: Comandos de referencia y limpieza**

### 12.1 Referencia rápida de comandos

| Categoría | Comando | Descripción |
|-----------|---------|-------------|
| **Contenedores** | `docker ps` | Lista contenedores activos |
| | `docker ps -a` | Lista todos los contenedores |
| | `docker run -d --name X -p Y:Z imagen` | Crea y ejecuta contenedor |
| | `docker stop X` | Detiene contenedor |
| | `docker start X` | Inicia contenedor |
| | `docker restart X` | Reinicia contenedor |
| | `docker rm X` | Elimina contenedor |
| | `docker rm -f X` | Fuerza eliminación |
| **Imágenes** | `docker images` | Lista imágenes |
| | `docker pull imagen:tag` | Descarga imagen |
| | `docker build -t nombre .` | Construye imagen |
| | `docker rmi imagen` | Elimina imagen |
| **Inspección** | `docker logs X` | Ver logs |
| | `docker logs -f X` | Seguir logs |
| | `docker exec -it X bash` | Shell interactivo |
| | `docker inspect X` | Metadatos completos |
| | `docker stats` | Uso de recursos |
| **Compose** | `docker compose up -d` | Inicia servicios |
| | `docker compose down` | Detiene y elimina |
| | `docker compose ps` | Estado de servicios |
| | `docker compose logs` | Logs de servicios |
| **Limpieza** | `docker system prune` | Elimina recursos no usados |
| | `docker system prune -a` | Elimina todo lo no usado |

### 12.2 Limpieza del sistema

```powershell
# Detener todos los contenedores
docker stop $(docker ps -q)

# Eliminar todos los contenedores
docker rm $(docker ps -aq)

# Eliminar imágenes no utilizadas
docker image prune

# Eliminar volúmenes no utilizados
docker volume prune

# Limpieza completa (contenedores, redes, imágenes sin usar)
docker system prune

# Limpieza agresiva (incluye imágenes)
docker system prune -a

# Ver espacio utilizado
docker system df
```

### 12.3 Errores comunes y soluciones

| Error | Causa | Solución |
|-------|-------|----------|
| `port is already allocated` | Puerto en uso | Cambiar puerto: `-p 8081:80` |
| `No such container` | Contenedor no existe | Verificar nombre: `docker ps -a` |
| `Cannot connect to Docker daemon` | Docker no iniciado | Iniciar Docker Desktop |
| `permission denied` | Permisos insuficientes | Ejecutar como administrador |
| `image not found` | Imagen no existe | Ejecutar `docker pull imagen` |
| `name already in use` | Nombre duplicado | Eliminar anterior: `docker rm nombre` |

## **Paso 13: Ejercicios de evaluación**

### Ejercicio 1: Despliegue básico
1. Descargr la imagen `httpd:2.4`
2. Crea un contenedor llamado `ejercicio1` en el puerto 9000
3. Verifica que responde en http://localhost:9000
4. Ve los logs del contenedor
5. Detén y elimina el contenedor

### Ejercicio 2: Volúmenes
1. Crea un directorio `C:\ejercicio2` con un archivo `index.html` personalizado
2. Ejecuta un contenedor que monte ese directorio
3. Modifica el archivo HTML y verificar que los cambios se reflejan
4. Documenta el comando usado

### Ejercicio 3: Dockerfile
Crear un Dockerfile que:
1. Usa `httpd:2.4-alpine` como base
2. Copia un sitio web con al menos 3 páginas HTML
3. Incluye un archivo CSS
4. Tén 'healthcheck' configurado
5. Construye y ejecuta la imagen

### Ejercicio 4: Docker Compose
Crea un archivo `docker-compose.yml` que defina:
1. Tres servicios web en puertos 9001, 9002, 9003
2. Cada uno con contenido diferente
3. Políticas de reinicio configuradas
4. Ejecutar y documentar los comandos usados

## **Resumen técnico**

### Conceptos cubiertos

1. **Docker**: arquitectura cliente-servidor, imágenes, contenedores, volúmenes, puertos
2. **Apache HTTP Server**: arquitectura, MPM, módulos, directivas de configuración
3. **Dockerfile**: instrucciones FROM, COPY, RUN, EXPOSE, CMD, HEALTHCHECK
4. **Docker Compose**: definición de servicios, redes, volúmenes, dependencias

### Flujo de trabajo recomendado

```
1. Desarrollo local
   └─► Volúmenes bind mount para cambios en tiempo real

2. Testing
   └─► Dockerfile para imagen reproducible

3. Producción
   └─► Docker Compose para orquestación
       └─► Políticas de reinicio
       └─► Healthchecks
       └─► Volúmenes nombrados para persistencia
```

### Recursos adicionales

- Documentación Docker: https://docs.docker.com
- Documentación Apache: https://httpd.apache.org/docs/2.4/
- Docker Hub httpd: https://hub.docker.com/_/httpd
- Docker Compose Specification: https://docs.docker.com/compose/compose-file/
