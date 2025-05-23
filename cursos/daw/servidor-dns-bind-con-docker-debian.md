# Tutorial: Crear un servidor DNS con BIND usando Docker

En este tutorial aprenderás a construir un servidor DNS local usando [BIND 9](https://www.isc.org/bind/) dentro de un contenedor [Docker](https://www.docker.com) basado en [Debian](https://www.debian.org). También aprenderás a probar que tu servidor responde correctamente desde tu máquina local.

## Paso 1: Prepara el entorno

1. Verifica que Docker esté instalado: `docker --version`.
2. Crea una carpeta para el proyecto con `mkdir ~/dns-bind-docker` y accede a ella con `cd ~/dns-bind-docker`. Allí guardarás todos los archivos necesarios para el servidor DNS y trabajarás desde ese directorio.

## Paso 2: Crea un archivo `Dockerfile` con la configuración del servidor DNS

1. Dentro del directorio del proyecto (`~/dns-bind-docker`), crea un archivo llamado `Dockerfile`.
2. Pega el siguiente contenido en ese archivo:

```Dockerfile
FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y bind9 dnsutils && \
    mkdir -p /etc/bind/zones && \
    rm -rf /var/lib/apt/lists/*

COPY named.conf /etc/bind/named.conf
COPY db.example.com /etc/bind/zones/db.example.com

EXPOSE 53/udp
EXPOSE 53/tcp

CMD ["named", "-g"]
```

3. A continuación se explica qué hace cada línea:

* `FROM debian:stable-slim`: usa como base una imagen oficial de Debian en su versión estable y ligera. Es ideal para contenedores porque ocupa poco espacio y tiene lo necesario para empezar.
* `RUN apt-get update && \`: actualiza la lista de paquetes disponibles desde los repositorios oficiales.
* `apt-get install -y bind9 dnsutils && \`: instala el servidor DNS (`bind9`) y herramientas como `dig` y `nslookup` (`dnsutils`).
* `mkdir -p /etc/bind/zones && \`: crea la carpeta donde se guardarán los archivos de zona. El parámetro `-p` asegura que no haya error si la carpeta ya existe.
* `rm -rf /var/lib/apt/lists/*`: elimina la caché de apt para reducir el tamaño final de la imagen. Esta caché ya no es necesaria una vez terminada la instalación.
* `COPY named.conf /etc/bind/named.conf`: copia tu archivo de configuración principal de BIND desde tu máquina local al contenedor, en la ubicación donde BIND lo espera.
* `COPY db.example.com /etc/bind/zones/db.example.com`: copia el archivo de zona DNS para `example.com` dentro del contenedor, en la carpeta `/etc/bind/zones`.
* `EXPOSE 53/udp`: informa a Docker que el contenedor usará el puerto 53 con protocolo UDP, que es el principal para resolver consultas DNS.
* `EXPOSE 53/tcp`: expone también el puerto 53 con protocolo TCP, que se usa para respuestas grandes o transferencias de zona.
* `CMD ["named", "-g"]`: define el comando que se ejecutará al iniciar el contenedor. `named` es el servicio de BIND, y el parámetro `-g` hace que se ejecute en primer plano, mostrando logs por consola para poder monitorear su funcionamiento.

## Paso 3: Configura BIND

1. Crea el archivo `named.conf` dentro del directorio del proyecto (`~/dns-bind-docker`) con este código:
   ```bash
   options {
       directory "/var/cache/bind";
       listen-on { any; };
       allow-query { any; };
       recursion no;
   };

   zone "example.com" {
       type master;
       file "/etc/bind/zones/db.example.com";
   };
   ```
   Explicación:
   - `directory`: le dice a BIND dónde guardar sus archivos de trabajo.
   - `listen-on`: le indica que escuche en todas las interfaces disponibles.
   - `allow-query`: permite consultas desde cualquier IP.
   - `recursion no`: desactiva la resolución recursiva (este servidor solo responde zonas propias, no resuelve dominios externos).
   - La sección `zone` declara una zona llamada `example.com`, indicando que este servidor es el **maestro** (autoridad principal) y especifica el archivo donde se encuentran los registros DNS.

2. Crea el archivo `db.example.com` dentro del directorio del proyecto (`~/dns-bind-docker`) con este código:
   ```bash
   $TTL    604800
   @       IN      SOA     ns1.example.com. admin.example.com. (
                             2         ; Serial
                        604800         ; Refresh
                         86400         ; Retry
                       2419200         ; Expire
                        604800 )       ; Negative Cache TTL

   @       IN      NS      ns1.example.com.
   ns1     IN      A       127.0.0.1
   www     IN      A       127.0.0.1
   ```
   Este archivo define los registros DNS de la zona:
   - `$TTL`: Tiempo de vida por defecto de los registros.
   - `SOA`: (Start of Authority) define el servidor principal y un correo de contacto (se usa `admin.example.com.` pero el punto se traduce a `admin@example.com`).
   - `NS`: define el nombre del servidor de nombres.
   - `A`: define direcciones IP para los hosts `ns1` y `www`.

## Paso 4: Construir y correr el contenedor

1. Construye la imagen de Docker:
   ```bash
   docker build -t my-bind-server .
   ```
   Esto crea una imagen Docker con el nombre `my-bind-server` usando el `Dockerfile` que preparaste. Docker copiará los archivos y configurará BIND dentro de la imagen.

2. Inicia el contenedor:
   ```bash
   docker run -d --name bind-server -p 53:53/udp -p 53:53/tcp my-bind-server
   ```
   Esto lanza el contenedor:
   - `-d` lo ejecuta en segundo plano (modo *detached*).
   - `--name bind-server` le pone un nombre identificador al contenedor.
   - `-p 53:53/udp -p 53:53/tcp` hace que el puerto DNS del contenedor sea accesible desde tu máquina.

3. Verifica que el contenedor está en marcha:
   ```bash
   docker ps
   ```
   Esto muestra todos los contenedores en ejecución. Deberías ver `bind-server` en la lista.

## Paso 5: Probar el servidor DNS local con `nslookup`

1. Haz una consulta DNS con [`nslookup`](https://en.wikipedia.org/wiki/Nslookup) desde tu máquina (Windows o GNU/Linux):

   ```bash
   nslookup www.example.com 127.0.0.1
   ```

   Si todo está funcionando correctamente, deberías ver una salida parecida a esta:

   ```
   Servidor:  UnKnown
   Address:  127.0.0.1

   Nombre:    www.example.com
   Address:  127.0.0.1
   ```
   Explicación:
   - `"Servidor: UnKnown"`: esto es normal cuando el servidor DNS que consultas (en este caso tu contenedor) no tiene un *hostname* definido o accesible desde Windows. No te preocupes.
   - `"Address: 127.0.0.1"` debajo de `"Nombre: www.example.com"` indica que tu servidor DNS ha respondido correctamente y ha devuelto la IP que configuraste en el archivo de zona (`db.example.com`).

2. Haz otra prueba para el servidor de nombres:

   ```bash
   nslookup ns1.example.com 127.0.0.1
   ```

   Esto consulta el registro `ns1` que también definiste. Es otra forma de confirmar que la zona está bien configurada.

3. Consulta una zona inexistente para ver el fallo controlado:

   ```bash
   nslookup noexiste.example.com 127.0.0.1
   ```

   Deberías ver un mensaje que indica que no se pudo encontrar la dirección, lo cual es normal si ese nombre no fue definido en la zona.


## Paso 6: Probar el servidor DNS local con `dig`

> Si usas Windows y no tienes `dig` instalado, puedes usarlo desde dentro del contenedor, ya que se instaló automáticamente con el paquete `dnsutils`. Para ello, abre una terminal y conéctate al contenedor en ejecución con `docker exec -it bind-server bash`. Una vez dentro del contenedor, sigue con los pasos indicados a continuación.

1. Haz una consulta DNS con `dig`:
   ```bash
   dig @127.0.0.1 www.example.com
   ```
   Aquí estás usando la herramienta [`dig`](https://en.wikipedia.org/wiki/Dig_(command)) para preguntarle al servidor local (127.0.0.1) cuál es la IP de `www.example.com`.
   Si todo funciona, deberías ver una sección como esta:

   ```
   ;; ANSWER SECTION:
   www.example.com.  604800  IN  A  127.0.0.1
   ```

   La sección `ANSWER SECTION` aparece solo si el nombre consultado existe en la zona y tiene un registro asociado.

2. Haz otra prueba para el servidor de nombres:
   ```bash
   dig @127.0.0.1 ns1.example.com
   ```
   Esto consulta el registro `ns1` que también definiste. La salida también debe contener una `ANSWER SECTION` con la IP `127.0.0.1`.

3. Consulta un nombre que no exista:
   ```bash
   dig @127.0.0.1 noexiste.example.com
   ```
   En este caso, el servidor responderá con un estado `NXDOMAIN` (nombre no existente), y no habrá sección `ANSWER SECTION`:

   ```
   ;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, ...
   ```

   Si el nombre no existe en la zona, la sección `ANSWER SECTION` no aparece. Esto es totalmente normal.

Y eso es todo. Ahora tienes un servidor DNS básico en funcionamiento dentro de un contenedor Docker. Puedes modificar los archivos de zona o añadir más zonas si quieres practicar más.
