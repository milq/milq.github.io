# Tutorial: Apache HTTP Server con Docker en Windows

En este tutorial aprenderás a descargar la imagen oficial de Apache HTTP Server con Docker, ejecutar una página web de ejemplo en el puerto 8080, montar la carpeta completa de configuración de Apache (`/usr/local/apache2/`) en tu Explorador de Windows para editar archivos fácilmente, crear tu propia imagen de Docker y subirla a un repositorio como Docker Hub.

## Paso 1: Prepara el entorno

1. **Instala Docker Desktop**  
   - Descarga [Docker Desktop para Windows](https://www.docker.com/products/docker-desktop/).
   - Sigue el asistente de instalación y reinicia tu computadora si es necesario.
   - Asegúrate de que Docker Desktop pueda ejecutar [contenedores de Linux](https://learn.microsoft.com/es-es/windows/wsl/tutorials/wsl-containers#install-docker-desktop).

2. **Verifica la instalación**  
   - Abre **PowerShell** o la **línea de comandos** (CMD).
   - Ejecuta `docker --version` para confirmar que Docker se instaló correctamente.

3. **Crea una cuenta en Docker Hub (opcional para el _push_)**  
   - Si planeas subir (_push_) tus imágenes, regístrate en [Docker Hub](https://hub.docker.com/).
   - Esto te permitirá almacenar imágenes en la nube.

## Paso 2: Haz _pull_ de la imagen oficial de Apache

1. **Abre la terminal**: abre PowerShell o CMD.

2. **Descarga la [imagen oficial](https://hub.docker.com/_/httpd)**  
   ```bash
   docker pull httpd:2.4
   ```
   - `httpd:2.4` es la etiqueta (_tag_) específica que indica la versión 2.4 de Apache.
   - Si no especificas la etiqueta, Docker descargará `latest`, pero es aconsejable usar una versión específica.

3. **Verifica la imagen descargada**  
   ```bash
   docker images
   ```
   - Deberías ver `httpd` en la lista de imágenes.

## Paso 3: Ejecuta un contenedor con Apache y monta `/usr/local/apache2/`

1. **Elige una carpeta local tuya en Windows**  
   - Crea una carpeta nueva en tu disco local, por ejemplo:  
     `C:\tu\ruta\local\apache`
   - En esa carpeta será para ver todos los archivos de configuración de Apache.

2. **Ejecuta el contenedor mapeando puertos y carpeta**  
   Desde la terminal, ejecuta:
   ```bash
   docker run -d --name my-apache \
     -p 8080:80 \
     -v C:\tu\ruta\local\apache:/usr/local/apache2 \
     httpd:2.4
   ```
   - `-d`: Inicia el contenedor en segundo plano (_detached_).
   - `--name my-apache`: Nombra el contenedor como _my-apache_.
   - `-p 8080:80`: Abre el servidor en `http://localhost:8080`.
   - `-v C:\tu\ruta\local\apache:/usr/local/apache2`: sincroniza la carpeta local con todo el directorio de Apache dentro del contenedor.

3. **Comprueba que el contenedor esté ejecutándose**  
   ```bash
   docker ps
   ```
   - Verás el contenedor `my-apache` ejecutándose en el puerto 8080.

## Paso 4: Accede y modifica archivos de Apache

1. **Abre la carpeta en Windows**  
   - Ve a `C:\tu\ruta\local\apache` con el Explorador de Windows.
   - Verás carpetas como: `conf`, `htdocs`, `logs`, `bin`, `modules`, etc.

2. **Coloca una página de ejemplo**  
   - Dentro de `htdocs` crea un archivo `index.html` con contenido simple. Por ejemplo:
     ```html
     <html>
     <head><title>Mi sitio en Apache</title></head>
     <body>
       <h1>¡Hola desde Apache en Docker!</h1>
     </body>
     </html>
     ```
   - Al guardar, el contenedor tendrá automáticamente este archivo como página de inicio.

3. **Prueba la página en el navegador**  
   - Abre:  
     ```
     http://localhost:8080
     ```
   - Deberías ver el contenido de `index.html` que acabas de crear.

## Paso 5: Personaliza la configuración de Apache

1. **Edita `httpd.conf`**  
   - Abre `C:\tu\ruta\local\apache\conf\httpd.conf` con tu editor de texto preferido (Notepad++, VS Code, etc.).
   - Aquí puedes modificar puertos, activar módulos, cambiar la carpeta raíz, etc.

2. **Verifica la configuración**  
   - Antes de reiniciar, comprueba si la configuración de Apache es válida:
     ```bash
     docker exec -it my-apache apachectl -t
     ```
     - Si aparece `Syntax OK`, todo está en orden.

3. **Reinicia el contenedor**  
   - Aplica los cambios reiniciando el contenedor:
     ```bash
     docker restart my-apache
     ```

## Paso 6: Crea tu propia imagen personalizada (_build_)

1. **Crea un [Dockerfile](https://docs.docker.com/build/concepts/dockerfile/)**  
   - En una nueva carpeta, crea un archivo llamado `Dockerfile` con el siguiente contenido:
     ```dockerfile
     FROM httpd:2.4
     COPY ./mi-sitio-web/ /usr/local/apache2/htdocs/
     ```
   - `FROM httpd:2.4` indica que partes de la imagen oficial de Apache.
   - `COPY ./mi-sitio-web/ /usr/local/apache2/htdocs/` copia tu proyecto web al contenedor.

2. **Organiza tu carpeta de proyecto**  
   - Dentro de la carpeta de tu proyecto, crea un subdirectorio `mi-sitio-web` con tus archivos HTML, CSS, JS, etc.

3. **Construye (_build_) tu imagen**  
   - En la terminal, sitúate en la ruta donde creaste el Dockerfile y ejecuta:
     ```bash
     docker build -t mi-apache-personalizado .
     ```
   - `-t mi-apache-personalizado` asigna un nombre y etiqueta a tu imagen.

## Paso 7: Prueba la imagen personalizada

1. **Ejecuta el contenedor desde la nueva imagen**  
   ```bash
   docker run -d --name custom-apache -p 8080:80 mi-apache-personalizado
   ```
2. **Verifica en el navegador**  
   - Ingresa a:
     ```
     http://localhost:8080
     ```
   - Verás la página de tu carpeta `mi-sitio-web`.

3. **Comprueba la lista de contenedores activos**  
   ```bash
   docker ps
   ```
   - Deberías encontrar `custom-apache` en ejecución.

## Paso 8: Haz un _push_ de tu imagen a Docker Hub

1. **Inicia sesión en Docker Hub**  
   ```bash
   docker login
   ```
   - Ingresa tus credenciales (usuario y contraseña) de Docker Hub.

2. **Renombra (_tag_) tu imagen para Docker Hub**  
   - Para subir tu imagen, necesita contener tu usuario de Docker Hub en la etiqueta:
     ```bash
     docker tag mi-apache-personalizado TU_USUARIO/mi-apache-personalizado:1.0
     ```
   - Reemplaza `TU_USUARIO` por tu nombre de usuario real y ponle la versión que gustes (`1.0`, `latest`, etc.).

3. **Haz el _push_ de la imagen**  
   ```bash
   docker push TU_USUARIO/mi-apache-personalizado:1.0
   ```
   - Espera a que Docker complete la carga de tu imagen al repositorio.

4. **Verifica en Docker Hub**  
   - Ve a tu cuenta en [Docker Hub](https://hub.docker.com/) y revisa que aparezca el repositorio `mi-apache-personalizado`.
