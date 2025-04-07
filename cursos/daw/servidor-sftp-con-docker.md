# Tutorial: Crea un servidor SFTP y transfiere desde un cliente

En este tutorial aprenderás a montar un servidor SFTP en un contenedor Debian, conectarte a él desde otro contenedor Debian actuando como cliente, y realizar la transferencia de un archivo y una carpeta. Todo se hará de forma local usando Docker.

## Paso 1: Prepara dos contenedores Debian

1. Crea una red Docker para que ambos contenedores puedan comunicarse entre sí:

   ```bash
   docker network create sftp-net
   ```

   > Este comando crea una red virtual llamada `sftp-net`. Así puedes conectar contenedores entre sí de forma aislada del resto del sistema.

2. Inicia el contenedor que actuará como **servidor SFTP**:

   ```bash
   docker run -dit --name sftp-server --network sftp-net debian bash
   ```

   > Este comando:
   > - `-dit`: ejecuta el contenedor en modo interactivo, en segundo plano, y con acceso a terminal.
   > - `--name sftp-server`: le da el nombre `sftp-server`.
   > - `--network sftp-net`: lo conecta a la red que creaste antes.
   > - `debian`: indica que se usará la imagen oficial de Debian.
   > - `bash`: es el comando que se ejecutará dentro del contenedor.

3. Inicia el contenedor que actuará como **cliente SFTP**:

   ```bash
   docker run -dit --name sftp-client --network sftp-net debian bash
   ```

   > Lo mismo que antes, pero el contenedor se llamará `sftp-client` y también se conectará a `sftp-net`.

## Paso 2: Configura el servidor SFTP

1. Entra al contenedor del servidor:

   ```bash
   docker exec -it sftp-server bash
   ```

   > Este comando te mete dentro del contenedor `sftp-server` en una sesión de terminal interactiva.

2. Instala el servidor SSH:

   ```bash
   apt update && apt install -y openssh-server
   ```

   > - `apt update`: actualiza la lista de paquetes disponibles.
   > - `apt install -y openssh-server`: instala el servidor SSH sin preguntar (gracias a `-y`). Esto es necesario para que el contenedor pueda aceptar conexiones SFTP.

3. Crea un nuevo usuario llamado `sftpuser`:

   ```bash
   useradd -m sftpuser
   passwd sftpuser
   ```

   > - `useradd -m sftpuser`: crea un usuario nuevo y le genera una carpeta `/home/sftpuser`.
   > - `passwd sftpuser`: te pedirá que definas una contraseña para ese usuario. La necesitarás para conectarte más adelante.

4. Crea y ajusta la carpeta donde se permitirá subir archivos:

   ```bash
   mkdir -p /home/sftpuser/uploads
   chown root:root /home/sftpuser
   chmod 755 /home/sftpuser
   chown sftpuser:sftpuser /home/sftpuser/uploads
   ```

   > - `mkdir -p /home/sftpuser/uploads`: crea la carpeta `uploads` donde se podrán subir archivos.
   > - `chown root:root /home/sftpuser`: la carpeta principal debe ser propiedad de `root` por seguridad.
   > - `chmod 755 /home/sftpuser`: da permisos de lectura y ejecución a todos, pero solo `root` podrá escribir en la raíz del directorio.
   > - `chown sftpuser:sftpuser /home/sftpuser/uploads`: da al usuario permisos completos sobre la carpeta `uploads`.

5. Edita el archivo de configuración del servidor SSH:

   ```bash
   nano /etc/ssh/sshd_config
   ```

   > Este comando abre el archivo en el editor de texto `nano`, utilizado comúnmente en sistemas GNU/Linux. En caso de que el editor no esté disponible y aparezca un mensaje indicando que `nano` no se encuentra instalado, puede añadirse fácilmente ejecutando `apt update && apt install -y nano`.

   > Para utilizar `nano`, simplemente navegue con las teclas de dirección, edite el contenido que sea necesario, y al finalizar presione `Ctrl + X`, luego `Y` para confirmar los cambios y `Enter` para guardar y salir del archivo.

   Agrega esto al final del archivo:

   ```
   Match User sftpuser
     ChrootDirectory /home/sftpuser
     ForceCommand internal-sftp
     AllowTcpForwarding no
   ```

   > - `Match User sftpuser`: aplica las siguientes reglas solo para el usuario `sftpuser`.
   > - `ChrootDirectory /home/sftpuser`: encierra al usuario en ese directorio; no podrá acceder al resto del sistema.
   > - `ForceCommand internal-sftp`: fuerza que solo se permita la conexión SFTP (sin acceso a shell).
   > - `AllowTcpForwarding no`: desactiva el reenvío de puertos por seguridad.

6. Inicia el servicio SSH:

   ```bash
   service ssh start
   ```

   > Este comando arranca el servidor SSH, permitiendo así que se pueda conectar el cliente por SFTP.

## Paso 3: Prepara el cliente SFTP

1. Entra al contenedor del cliente:

   ```bash
   docker exec -it sftp-client bash
   ```

   > Te mete dentro del contenedor `sftp-client` para trabajar en su terminal.

2. Instala el cliente SSH:

   ```bash
   apt update && apt install -y openssh-client
   ```

   > - `openssh-client` permite hacer conexiones SSH/SFTP desde el contenedor cliente hacia el servidor.

3. Crea un archivo y una carpeta de prueba:

   ```bash
   echo "Hola mundo" > archivo.txt
   ```

   > Crea un archivo llamado `archivo.txt` con el contenido `Hola mundo`.

   ```bash
   mkdir carpeta
   echo "Contenido en carpeta" > carpeta/archivo_en_carpeta.txt
   ```

   > - `mkdir carpeta`: crea una carpeta.
   > - `echo "Contenido..." > ...`: crea un archivo dentro de esa carpeta.

## Paso 4: Conéctate al servidor y transfiere archivos

1. Conéctate por SFTP al servidor:

   ```bash
   sftp sftpuser@sftp-server
   ```

   > - `sftp`: abre una sesión SFTP.
   > - `sftpuser@sftp-server`: te conectas con el usuario `sftpuser` al host `sftp-server` (nombre del contenedor, gracias a la red Docker).

   Si te pregunta si confías en el host, escribe `yes`. Luego, ingresa la contraseña.

2. Navega al directorio de subida en el servidor:

   ```sftp
   cd uploads
   ```

   > Este comando cambia el directorio de trabajo dentro del servidor SFTP al directorio `uploads`, que es donde el usuario `sftpuser` tiene permiso de escritura.  
   > Es importante hacerlo antes de realizar cualquier carga de archivos, ya que el usuario está restringido a su carpeta raíz (`/home/sftpuser`), y solo `uploads` tiene permisos de escritura.

3. Sube el archivo al servidor:

   ```sftp
   put archivo.txt
   ```

   > Este comando transfiere el archivo `archivo.txt` desde el contenedor cliente al servidor, colocándolo en la carpeta `uploads`.

4. Sube la carpeta completa:

   ```sftp
   put -r carpeta
   ```

   > `-r` significa "recursivo", así que sube todo el contenido de la carpeta `carpeta`.

5. Verifica que los archivos estén en el servidor:

   ```sftp
   ls
   ls carpeta
   ```

   > - `ls`: muestra los archivos en el directorio actual (`uploads`).
   > - `ls carpeta`: muestra el contenido de la carpeta que subiste.

6. Sal de la sesión SFTP:

   ```sftp
   bye
   ```

   > Finaliza la sesión SFTP y vuelve a la línea de comandos del cliente.

¡Y listo! Has configurado correctamente un servidor SFTP usando Docker y Debian. Aprendiste cómo crear usuarios, limitar su acceso, subir archivos y carpetas de manera segura usando SFTP.

## Paso 5 (Opcional): Automatiza todo con `docker-compose`

Con este paso podrás levantar tanto el servidor como el cliente SFTP ya configurados con un solo comando, usando `docker-compose`.

1. Crea un archivo llamado `docker-compose.yml` en una carpeta de tu máquina local:

   ```bash
   mkdir sftp-proyecto
   cd sftp-proyecto
   nano docker-compose.yml
   ```

2. Copia y pega este contenido dentro del archivo:

   ```yaml
   version: '3.8'

   services:
     sftp-server:
       image: debian
       container_name: sftp-server
       networks:
         - sftp-net
       command: bash -c "
         apt update && \
         apt install -y openssh-server && \
         useradd -m sftpuser && echo 'sftpuser:1234' | chpasswd && \
         mkdir -p /home/sftpuser/uploads && \
         chown root:root /home/sftpuser && \
         chmod 755 /home/sftpuser && \
         chown sftpuser:sftpuser /home/sftpuser/uploads && \
         echo 'Match User sftpuser' >> /etc/ssh/sshd_config && \
         echo '  ChrootDirectory /home/sftpuser' >> /etc/ssh/sshd_config && \
         echo '  ForceCommand internal-sftp' >> /etc/ssh/sshd_config && \
         echo '  AllowTcpForwarding no' >> /etc/ssh/sshd_config && \
         service ssh start && \
         tail -f /dev/null
       "

     sftp-client:
       image: debian
       container_name: sftp-client
       networks:
         - sftp-net
       command: bash -c "
         apt update && \
         apt install -y openssh-client && \
         echo 'Hola mundo' > archivo.txt && \
         mkdir carpeta && \
         echo 'Contenido en carpeta' > carpeta/archivo_en_carpeta.txt && \
         tail -f /dev/null
       "

   networks:
     sftp-net:
       driver: bridge
   ```

   > Explicación:
   > - Define dos servicios: `sftp-server` y `sftp-client`.
   > - Ambos están basados en Debian.
   > - El servidor instala OpenSSH, configura el usuario y las carpetas necesarias.
   > - El cliente crea archivos de prueba.
   > - `tail -f /dev/null` mantiene ambos contenedores corriendo.

3. Levanta los contenedores:

   ```bash
   docker-compose up -d
   ```

   > Esto descargará las imágenes (si no las tienes), creará la red, configurará los contenedores y los dejará en ejecución.

4. Para entrar en cada uno:

   - Servidor:
     ```bash
     docker exec -it sftp-server bash
     ```
   - Cliente:
     ```bash
     docker exec -it sftp-client bash
     ```
