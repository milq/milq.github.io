# Tutorial: Servidor Nginx con Docker en Windows

En este tutorial aprenderás a descargar la imagen oficial de Nginx con Docker, a ejecutar una página web de ejemplo en el puerto 8080, a montar la carpeta de contenido en tu Explorador de Windows para editar archivos fácilmente, a crear tu propia imagen de Docker y a subirla a un repositorio como Docker Hub.

## Paso 1: Prepara el entorno

1. **Instala Docker Desktop**
   - Descarga [Docker Desktop para Windows](https://www.docker.com/products/docker-desktop/).
   - Sigue el asistente de instalación y reinicia tu computadora si es necesario.
   - Asegúrate de que Docker Desktop pueda ejecutar [contenedores de Linux](https://learn.microsoft.com/es-es/windows/wsl/tutorials/wsl-containers#install-docker-desktop).

2. **Verifica la instalación**
   - Abre **PowerShell** o la **línea de comandos** (CMD).
   - Ejecuta:
     ```bash
     docker --version
     ```
     para confirmar que Docker se instaló correctamente.

3. **Crea una cuenta en Docker Hub (opcional para el _push_)**
   - Si planeas subir (_push_) tus imágenes personalizadas, regístrate en [Docker Hub](https://hub.docker.com/).
   - Esto te permitirá almacenar imágenes en la nube.

## Paso 2: Haz _pull_ de la imagen oficial de Nginx

1. **Abre la terminal**: puede ser PowerShell o CMD.

2. **Descarga la [imagen oficial](https://hub.docker.com/_/nginx)**
   ```bash
   docker pull nginx
   ```
   - Si no especificas la etiqueta, Docker descargará `latest` (la versión más reciente disponible).

3. **Verifica la imagen descargada**
   ```bash
   docker images
   ```
   - Deberías ver `nginx` en la lista de imágenes.

## Paso 3: Ejecuta un contenedor con Nginx y monta la carpeta de contenido

1. **Elige una carpeta local en Windows**
   - Crea una carpeta nueva en tu disco local, por ejemplo:
     ```
     C:\tu\ruta\local\nginx
     ```
   - Aquí colocarás tus archivos HTML, CSS y todo el contenido que quieras servir con Nginx.

2. **Ejecuta el contenedor mapeando puertos y la carpeta**
   Desde la terminal, ejecuta:
   ```bash
   docker run -d --name my-nginx \
     -p 8080:80 \
     -v C:\tu\ruta\local\nginx:/usr/share/nginx/html \
     nginx
   ```
   - `-d`: Inicia el contenedor en segundo plano (_detached_).
   - `--name my-nginx`: Nombra el contenedor como _my-nginx_.
   - `-p 8080:80`: Abre el servidor en `http://localhost:8080`.
   - `-v C:\tu\ruta\local\nginx:/usr/share/nginx/html`: sincroniza la carpeta local con la carpeta de contenido por defecto de Nginx.

3. **Comprueba que el contenedor esté ejecutándose**
   ```bash
   docker ps
   ```
   - Verás el contenedor `my-nginx` ejecutándose en el puerto 8080.

## Paso 4: Accede y modifica los archivos del sitio

1. **Abre la carpeta en Windows**
   - Ve a `C:\tu\ruta\local\nginx` con el Explorador de Windows.
   - Aquí podrás colocar tu archivo `index.html` (o los que prefieras).

2. **Crea una página de ejemplo**
   - Dentro de esa carpeta, crea un archivo `index.html` con el siguiente contenido:
     ```html
     <html>
       <head><title>Mi sitio en Nginx</title></head>
       <body>
         <h1>¡Hola desde Nginx en Docker!</h1>
       </body>
     </html>
     ```
   - Al guardar, el contenedor usará automáticamente este archivo como página principal.

3. **Prueba la página en el navegador**
   - Abre:
     ```
     http://localhost:8080
     ```
   - Deberías ver el contenido de `index.html` que acabas de crear.

## Paso 5: Personaliza la configuración de Nginx

Para configurar Nginx, normalmente se editan los archivos dentro de `/etc/nginx`, incluyendo `nginx.conf` y los sitios en `conf.d/`. En este tutorial, estamos montando solo la carpeta de contenido (`/usr/share/nginx/html`). Existen dos opciones principales para personalizar la configuración:

1. **Editar la configuración dentro del contenedor**
   - Puedes entrar al contenedor y modificar directamente:
     ```bash
     docker exec -it my-nginx /bin/bash
     ```
   - Allí dentro, verás la configuración en `/etc/nginx/nginx.conf` y en `/etc/nginx/conf.d/default.conf`.
   - Tras editar, reinicia el contenedor:
     ```bash
     docker restart my-nginx
     ```

2. **Montar también la carpeta de configuración**
   - Si quieres editar archivos de configuración desde Windows, podrías mapear otra carpeta local a `/etc/nginx` o `/etc/nginx/conf.d`. Sin embargo, es importante que esa carpeta contenga los archivos de configuración iniciales de Nginx para que el servidor pueda arrancar correctamente.

## Paso 6: Crea tu propia imagen personalizada (_build_)

1. **Crea un [Dockerfile](https://docs.docker.com/build/concepts/dockerfile/)**
   - En una nueva carpeta, crea un archivo llamado `Dockerfile` con el siguiente contenido:
     ```dockerfile
     FROM nginx
     COPY ./mi-sitio-web/ /usr/share/nginx/html/
     ```
   - `FROM nginx` indica que partes de la imagen oficial de Nginx (tomando su versión _latest_ por defecto).
   - `COPY ./mi-sitio-web/ /usr/share/nginx/html/` copia tu sitio web estático al contenedor.

2. **Organiza tu carpeta de proyecto**
   - Dentro de la carpeta donde está tu Dockerfile, crea un subdirectorio `mi-sitio-web` con tus archivos HTML, CSS, JS, etc.

3. **Construye (_build_) tu imagen**
   - En la terminal, ubícate en la carpeta donde creaste el Dockerfile y ejecuta:
     ```bash
     docker build -t mi-nginx-personalizado .
     ```
   - `-t mi-nginx-personalizado` asigna un nombre y etiqueta a tu imagen personalizada.

## Paso 7: Prueba la imagen personalizada

1. **Ejecuta el contenedor desde la nueva imagen**
   ```bash
   docker run -d --name custom-nginx -p 8080:80 mi-nginx-personalizado
   ```

2. **Verifica en el navegador**
   - Ingresa a:
     ```
     http://localhost:8080
     ```
   - Deberías ver la página de tu carpeta `mi-sitio-web`.

3. **Comprueba la lista de contenedores activos**
   ```bash
   docker ps
   ```
   - Deberías encontrar `custom-nginx` en ejecución.

## Paso 8: Haz un _push_ de tu imagen a Docker Hub

1. **Inicia sesión en Docker Hub**
   ```bash
   docker login
   ```
   - Ingresa tus credenciales (usuario y contraseña) de Docker Hub.

2. **Renombra (_tag_) tu imagen para Docker Hub**
   - Para subir tu imagen, necesita contener tu usuario de Docker Hub en la etiqueta:
     ```bash
     docker tag mi-nginx-personalizado TU_USUARIO/mi-nginx-personalizado:1.0
     ```
   - Reemplaza `TU_USUARIO` por tu nombre de usuario real en Docker Hub y elige la versión que gustes (`1.0`, `latest`, etc.).

3. **Haz el _push_ de la imagen**
   ```bash
   docker push TU_USUARIO/mi-nginx-personalizado:1.0
   ```
   - Espera a que Docker complete la subida de tu imagen al repositorio.

4. **Verifica en Docker Hub**
   - Ve a tu cuenta en [Docker Hub](https://hub.docker.com/) y revisa que aparezca el repositorio `mi-nginx-personalizado`.
