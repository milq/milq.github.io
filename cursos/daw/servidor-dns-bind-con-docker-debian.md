# Tutorial: Crear un servidor DNS con BIND usando Docker (Corregido)

Bienvenido a este tutorial práctico. Vamos a desmitificar cómo funciona Internet construyendo una de sus piezas fundamentales: un servidor DNS. Imagina el DNS como la guía telefónica de la red; sin él, tendríamos que memorizar números IP (como 192.168.1.1) en lugar de nombres fáciles (como google.com). Usaremos [**BIND9**](https://www.isc.org/bind/), el software estándar de la industria, y lo encapsularemos en **Docker**. Docker nos permite crear una "caja" aislada con todo lo necesario preinstalado, evitando ensuciar tu sistema operativo principal. Al finalizar, tendrás tu propio servidor capaz de traducir nombres de dominio a direcciones IP en tu máquina local.

## Paso 1: Preparación del entorno de trabajo

Antes de construir cualquier edificio, necesitamos un terreno limpio y organizado. En el mundo de los sistemas y DevOps, el orden es crucial. Vamos a crear un espacio de trabajo dedicado donde residirán nuestros archivos de configuración y nuestra "receta" de Docker. Esto evita conflictos con otros archivos de tu ordenador y nos permite tener una visión clara de qué elementos componen nuestro servicio. Si en el futuro quieres borrar el proyecto, solo tendrás que eliminar esta carpeta.

1.  **Verificación e instalación**
    Lo primero es asegurarnos de que tenemos los cimientos listos. Docker es el motor que ejecutará nuestro servidor, por lo que verificamos su instalación. Luego, creamos un directorio específico. Al usar `mkdir` y `cd`, estamos delimitando nuestro entorno de trabajo para asegurarnos de que todos los comandos posteriores se ejecuten en el contexto correcto.

    ```bash
    docker --version
    mkdir ~/dns-bind-docker
    cd ~/dns-bind-docker
    ```

## Paso 2: Configuración del cerebro del DNS (BIND)

Un servidor sin configuración es como un cerebro en blanco. En este paso, vamos a definir las reglas del juego. BIND necesita saber dos cosas fundamentales: **cómo comportarse** (opciones globales) y **qué datos responder** (zonas). A diferencia de otros tutoriales, creamos estos archivos *antes* de configurar Docker, porque Docker necesitará copiarlos durante su construcción. Si no existen ahora, la construcción de la imagen fallará. Estamos definiendo la lógica que luego inyectaremos en el contenedor.

1.  **El archivo de configuración principal (`named.conf`)**
    Este archivo es el panel de control. Aquí le decimos a BIND cosas vitales: en qué puertos escuchar, a quién permitirle hacer preguntas y qué dominios ("zonas") administramos. Vamos a configurar una zona llamada `example.com` y desactivar la recursión para que el servidor se centre solo en sus propios datos, actuando como una autoridad.

    Crea el archivo `named.conf` en tu carpeta `~/dns-bind-docker`:

    ```text
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

2.  **El archivo de Zona (`db.example.com`)**
    Si `named.conf` es el índice, este archivo es la página con el contenido. Aquí definimos la "verdad" sobre el dominio `example.com`. Especificamos qué IP corresponde a `www` o `ns1`. Es una base de datos de texto plano que mapea nombres humanos a direcciones técnicas.

    Crea el archivo `db.example.com` en la misma carpeta:

    ```text
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

## Paso 3: La receta de la imagen (Dockerfile)

Ahora que tenemos los datos (la configuración), necesitamos construir el "cuerpo" del servidor. El `Dockerfile` es una receta de cocina paso a paso que Docker leerá para cocinar una imagen. En lugar de instalar Linux, actualizarlo, e instalar BIND manualmente cada vez, escribimos las instrucciones una sola vez aquí. Esto garantiza que, si compartes este archivo con un compañero en China o en Marte, obtendrá exactamente el mismo servidor que tú, bit a bit.

1.  **Creación del archivo Dockerfile**
    Este archivo le dice a Docker: "Empieza con un sistema Debian ligero, instala BIND, crea las carpetas necesarias y, lo más importante, **copia** los archivos de configuración que creamos en el paso anterior dentro de la imagen". También ajustamos permisos para que el usuario `bind` pueda leerlos sin problemas.

    Crea un archivo llamado `Dockerfile` (sin extensión) y pega esto:

    ```Dockerfile
    FROM debian:stable-slim

    # Instalamos BIND9 y herramientas DNS, y limpiamos basura para que la imagen pese poco
    RUN apt-get update && \
        apt-get install -y bind9 dnsutils && \
        mkdir -p /etc/bind/zones && \
        rm -rf /var/lib/apt/lists/*

    # Copiamos nuestros archivos de configuración al lugar correcto dentro del contenedor
    COPY named.conf /etc/bind/named.conf
    COPY db.example.com /etc/bind/zones/db.example.com

    # Exponemos el puerto DNS estándar (53)
    EXPOSE 53/udp
    EXPOSE 53/tcp

    # Comando de arranque: ejecuta BIND en primer plano (-g)
    CMD ["named", "-g"]
    ```

## Paso 4: Construcción y Despliegue

Ha llegado el momento de la verdad. Primero, "compilaremos" nuestra receta para crear una imagen estática. Luego, instanciaremos esa imagen en un contenedor en ejecución. Aquí haremos un truco importante: **cambiaremos el puerto**. Tu ordenador personal ya usa el puerto 53 para navegar por Internet. Si intentamos usar el mismo, habrá un conflicto. Por eso, mapearemos el puerto 5353 de tu máquina al puerto 53 del contenedor.

1.  **Construir la imagen (Build)**
    Con este comando, Docker lee el `Dockerfile` y ejecuta cada línea. Verás cómo descarga Debian e instala los paquetes. La opción `-t my-bind-server` sirve para "etiquetar" (bautizar) la imagen, de modo que luego podamos referirnos a ella por un nombre sencillo en lugar de un código numérico complejo.

    ```bash
    docker build -t my-bind-server .
    ```

2.  **Ejecutar el contenedor (Run)**
    Ahora lanzamos el servidor. Usamos `-d` para que corra en segundo plano y no bloquee la terminal. La parte clave es `-p 5353:53`. Esto significa: "Todo lo que llegue al puerto 5353 de mi laptop, envíalo al puerto 53 del contenedor". Así evitamos chocar con el DNS de tu Windows o Linux.

    ```bash
    docker run -d --name bind-server -p 5353:53/udp -p 5353:53/tcp my-bind-server
    ```

    Verifica que corre con:
    ```bash
    docker ps
    ```

## Paso 5: Pruebas de funcionamiento

Un administrador de sistemas nunca asume que algo funciona; lo comprueba. Vamos a interrogar a nuestro servidor recién nacido. Usaremos herramientas estándar como `dig` (Domain Information Groper). Recuerda que, como cambiamos el puerto al 5353, debemos especificarlo explícitamente en nuestras consultas, o de lo contrario nuestra computadora intentará preguntar al servidor DNS habitual de internet y no encontrará nuestra zona privada `example.com`.

1.  **Prueba de resolución positiva**
    Preguntemos: "¿Quién es www.example.com?". Usamos `@127.0.0.1` para forzar que la pregunta vaya a nuestra propia máquina local, y `-p 5353` para entrar por el puerto correcto del contenedor. Si responde `127.0.0.1`, ¡felicidades! Tu servidor está vivo y respondiendo.

    ```bash
    dig @127.0.0.1 -p 5353 [www.example.com](https://www.example.com)
    ```
    *Busca la "ANSWER SECTION" en la respuesta.*

2.  **Prueba de resolución negativa (Fallo controlado)**
    Es igual de importante saber que el servidor sabe decir "no lo sé". Preguntaremos por un subdominio que no existe. Esto verifica que el servidor está leyendo la zona correctamente y no inventando datos. Esperamos un estado `NXDOMAIN` (Non-Existent Domain).

    ```bash
    dig @127.0.0.1 -p 5353 noexiste.example.com
    ```
    *En este caso, no debe haber "ANSWER SECTION", sino un status: NXDOMAIN.*

### ¡Misión Cumplida!

Has creado, configurado y desplegado un servidor DNS funcional encapsulado en Docker. Has aprendido a manejar archivos de zona, redirección de puertos y construcción de imágenes.
