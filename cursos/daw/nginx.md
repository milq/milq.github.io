# Tutorial: Nginx con Docker en Windows

En este tutorial aprenderás a descargar la imagen oficial de Nginx con Docker, ejecutar una página web de ejemplo en el puerto 8080, montar las carpetas de Nginx en tu Explorador de Windows para editar archivos fácilmente, crear tu propia imagen de Docker y subirla a un repositorio como Docker Hub.

## Paso 1: Prepara el entorno

1. **Instala Docker Desktop**
   - Descarga [Docker Desktop para Windows](https://www.docker.com/products/docker-desktop).
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
   - Si planeas subir (_push_) tus imágenes, regístrate en [Docker Hub](https://hub.docker.com/).
   - Esto te permitirá almacenar imágenes en la nube.

## Paso 2: Haz _pull_ de la imagen oficial de Nginx

1. **Abre la terminal**
   - Abre PowerShell o CMD.

2. **Descarga la [imagen oficial de Nginx](https://hub.docker.com/_/nginx)**
   ```bash
   docker pull nginx
   ```
   - Esto descargará la versión `latest` de Nginx.
   - Puedes usar una etiqueta específica (p. ej. `nginx:1.25`) si deseas una versión en particular.

3. **Verifica la imagen descargada**
   ```bash
   docker images
   ```
   - Deberías ver `nginx` en la lista de imágenes.

## Paso 3: Ejecuta un contenedor con Nginx y prepara tus carpetas

### Opción A: Solo quieres editar los archivos HTML

Si únicamente necesitas modificar la página web (HTML, CSS, JS), puedes **montar** la carpeta de contenido predeterminada de Nginx, `/usr/share/nginx/html`.

1. **Crea y ejecuta el contenedor montando la carpeta HTML**
   Asumiendo que en `C:\tu\ruta\local\html` tienes o tendrás tu sitio web:
   ```bash
   docker run -d --name my-nginx \
     -p 8080:80 \
     -v C:\tu\ruta\local\html:/usr/share/nginx/html \
     nginx
   ```
   - `-d`: Inicia el contenedor en segundo plano.
   - `--name my-nginx`: Nombra el contenedor.
   - `-p 8080:80`: Podrás acceder a tu sitio en `http://localhost:8080`.
   - `-v`: Monta la carpeta local donde está tu sitio en el contenedor.

2. **Comprueba que el contenedor esté en ejecución**
   ```bash
   docker ps
   ```
   - Debes ver el contenedor `my-nginx` en el puerto 8080 y con “Up” (ejecutándose).

> **Pro _tip_:** Con este método, no necesitas copiar nada del contenedor a tu carpeta local. Simplemente dejas tu proyecto web en `C:\tu\ruta\local\html` y se reflejará automáticamente en el contenedor.

### Opción B: Quieres editar HTML y la configuración de Nginx

Si necesitas, además de la parte web, cambiar la configuración (por ejemplo `nginx.conf`, directivas de servidor, etc.), lo más cómodo es copiarla del contenedor a tu carpeta local y volver a montar esa carpeta.

1. **Prepara una carpeta local en Windows**
   - Crea una carpeta: `C:\tu\ruta\local\nginx`.
   - En esta carpeta colocarás la configuración (`nginx.conf`, etc.) y el contenido HTML.

2. **Crea y ejecuta un contenedor temporal para copiar los archivos base**
   ```bash
   docker run -d --name temp-nginx nginx
   ```
3. **Copia la configuración y los archivos web desde el contenedor temporal**
   ```bash
   docker cp temp-nginx:/etc/nginx C:\tu\ruta\local\nginx
   docker cp temp-nginx:/usr/share/nginx/html C:\tu\ruta\local\nginx
   ```
   - El primer comando copia la configuración de Nginx.
   - El segundo copia la carpeta donde se encuentra la página de ejemplo.

4. **Elimina el contenedor temporal**
   ```bash
   docker rm -f temp-nginx
   ```

5. **Inicia un nuevo contenedor, montando ambas rutas**
   ```bash
   docker run -d --name my-nginx \
     -p 8080:80 \
     -v C:\tu\ruta\local\nginx\nginx:/etc/nginx \
     -v C:\tu\ruta\local\nginx\html:/usr/share/nginx/html \
     nginx
   ```
   - Con este comando, cualquier cambio que hagas en `C:\tu\ruta\local\nginx\nginx` o en `C:\tu\ruta\local\nginx\html` se reflejará directamente en el contenedor.

6. **Verifica que esté en ejecución**
   ```bash
   docker ps
   ```
   - Asegúrate de ver `my-nginx` activo y “Up”.

## Paso 4: Accede y modifica archivos de Nginx

1. **Abre la carpeta en Windows**
   - Ve a `C:\tu\ruta\local\nginx` con el Explorador de Windows.
   - Encontrarás subcarpetas como `nginx` (con la configuración principal) y `html` (con la web por defecto).

2. **Coloca una página de ejemplo**
   - Dentro de la carpeta `html` crea (o reemplaza) un archivo `index.html` con contenido simple. Por ejemplo:
     ```html
     <html>
     <head><title>Mi sitio en Nginx</title></head>
     <body>
       <h1>¡Hola desde Nginx en Docker!</h1>
     </body>
     </html>
     ```
   - Al guardar, el contenedor mostrará automáticamente este archivo como página de inicio.

3. **Prueba la página en el navegador**
   - Abre `http://localhost:8080`
   - Deberías ver el contenido de `index.html` que acabas de crear.

## Paso 5: Personaliza la configuración de Nginx

1. **Abre `nginx.conf` en tu editor favorito**
   - En la carpeta `C:\tu\ruta\local\nginx\nginx`, localiza el archivo `nginx.conf`.
   - Allí verás directivas como `http {}`, `server {}`, etc.

2. **Ejemplo de cambio: `server_name localhost;`**
   - Dentro del bloque `server { ... }`, localiza (o añade) la directiva:
     ```nginx
     server_name localhost;
     ```
   - Esto le indica a Nginx cómo identificar este bloque de servidor.

3. **Reinicia el contenedor**
   - Para que los cambios surtan efecto, reinicia el contenedor:
     ```bash
     docker restart my-nginx
     ```

4. **Verifica la configuración**
   - Comprueba si la configuración de Nginx es válida:
     ```bash
     docker exec -it my-nginx nginx -t
     ```
   - Si aparece `syntax is ok`, todo está en orden.
   - Si no, revisa cuidadosamente tu `nginx.conf` en busca de errores de sintaxis.

## Paso 6: Crea tu propia imagen personalizada (_build_)

Si deseas una imagen que ya incluya tu sitio web o tu configuración por defecto, puedes crear un `Dockerfile`.

1. **Crea un [Dockerfile](https://docs.docker.com/build/concepts/dockerfile/)**
   En una carpeta nueva (por ejemplo `C:\proyectos\mi-nginx`), crea un archivo llamado `Dockerfile` con el siguiente contenido:
   ```dockerfile
   FROM nginx
   COPY ./mi-sitio-web/ /usr/share/nginx/html/
   ```
   - `FROM nginx` indica que partes de la imagen oficial de Nginx (la última versión disponible).
   - `COPY ./mi-sitio-web/ /usr/share/nginx/html/` copia tu proyecto web al contenedor.

2. **Organiza tu carpeta de proyecto**
   - Dentro de la misma carpeta donde está el `Dockerfile`, crea un subdirectorio `mi-sitio-web` con tus archivos HTML, CSS, JS, etc.

3. **Construye (_build_) tu imagen**
   - En la terminal, ve a la ruta donde creaste el Dockerfile y ejecuta:
     ```bash
     docker build -t mi-nginx-personalizado .
     ```
   - `-t mi-nginx-personalizado` asigna un nombre y etiqueta a tu imagen.

## Paso 7: Prueba la imagen personalizada

1. **Ejecuta el contenedor desde la nueva imagen**
   ```bash
   docker run -d --name custom-nginx -p 8080:80 mi-nginx-personalizado
   ```
2. **Verifica en el navegador**
   - Abre:
     ```
     http://localhost:8080
     ```
   - Verás la página que está dentro de `mi-sitio-web`.

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
   - Ingresa tus credenciales de Docker Hub.

2. **Etiqueta (_tag_) tu imagen para Docker Hub**
   ```bash
   docker tag mi-nginx-personalizado TU_USUARIO/mi-nginx-personalizado:1.0
   ```
   - Cambia `TU_USUARIO` por tu usuario real de Docker Hub y usa la versión que prefieras (`1.0`, `latest`, etc.).

3. **Haz el _push_ de tu imagen**
   ```bash
   docker push TU_USUARIO/mi-nginx-personalizado:1.0
   ```
   - Espera a que la imagen se cargue en tu repositorio.

4. **Verifica en Docker Hub**
   - Ve a tu cuenta en [Docker Hub](https://hub.docker.com/) y revisa que aparezca tu repositorio con la imagen `mi-nginx-personalizado`.
