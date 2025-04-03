# Tutorial: Crear un servidor DNS con BIND usando Docker

En este tutorial aprenderás a construir un servidor DNS local usando [BIND 9](https://www.isc.org/bind/) dentro de un contenedor [Docker](https://www.docker.com) basado en [Debian](https://www.debian.org). También aprenderás a probar que tu servidor responde correctamente desde tu máquina local.

## Paso 1: Prepara el entorno

1. Verifica que Docker esté instalado: `docker --version`.
2. Crea una carpeta de trabajo para el proyecto: `mkdir ~/dns-bind-docker && cd ~/dns-bind-docker`. Esto crea un directorio donde guardarás todos los archivos necesarios para el servidor DNS. Luego entras en ese directorio para trabajar desde allí.

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

1. Crea el archivo `named.conf`:
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

2. Crea el archivo `db.example.com`:
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

## Paso 4: Construye y corre el contenedor

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

3. Verifica que el contenedor está en marcha: `docker ps`. Esto muestra todos los contenedores en ejecución. Deberías ver `bind-server` en la lista.

## Paso 5: Prueba el servidor DNS local

1. Haz una consulta DNS con [`dig`](https://en.wikipedia.org/wiki/Dig_(command)):
   ```bash
   dig @127.0.0.1 www.example.com
   ```
   Aquí estás usando la herramienta [`dig`](https://en.wikipedia.org/wiki/Dig_(command)) para preguntarle al servidor local (127.0.0.1) cuál es la IP de `www.example.com`. Si todo funciona, deberías ver una respuesta con la IP `127.0.0.1`.

2. Haz otra prueba para el servidor de nombres:
   ```bash
   dig @127.0.0.1 ns1.example.com
   ```
   Esto consulta el registro `ns1` que también definiste. Es otra forma de confirmar que la zona está bien configurada.

3. Consulta una zona inexistente para ver el fallo controlado:
   ```bash
   dig @127.0.0.1 noexiste.example.com
   ```
   Deberías ver una respuesta vacía, lo cual es normal si ese nombre no fue definido en la zona.

Y eso es todo. Ahora tienes un servidor DNS básico en funcionamiento dentro de un contenedor Docker. Puedes modificar los archivos de zona o añadir más zonas si quieres practicar más.
