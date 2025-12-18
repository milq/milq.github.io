# Tutorial: Apache HTTP Server con Docker en Windows

En este tutorial aprenderás a desplegar, configurar y administrar Apache HTTP Server mediante contenedores Docker. Se cubren los fundamentos de ambas tecnologías de forma progresiva, desde la ejecución básica hasta la creación de imágenes personalizadas y orquestación con Docker Compose.



## **Paso 1: Verificación del entorno Docker**

Antes de comenzar a trabajar con contenedores y desplegar servidores web, es absolutamente fundamental asegurarnos de que nuestro entorno de trabajo está correctamente configurado. Docker es una plataforma que nos permite ejecutar aplicaciones en contenedores aislados, pero para que funcione correctamente necesitamos que el software esté instalado y que el servicio (llamado "daemon") esté en ejecución. En este primer paso, realizaremos una serie de verificaciones sistemáticas para confirmar que Docker está listo para usar. Si alguna de estas verificaciones falla, no te preocupes: te proporcionaremos las instrucciones necesarias para solucionar cada problema. Piensa en este paso como la "revisión técnica" antes de emprender un viaje: es mejor detectar cualquier problema ahora que cuando estés a mitad del tutorial.

### 1.1 Abrir PowerShell

PowerShell es la terminal de comandos moderna de Windows, y será nuestra herramienta principal durante todo este tutorial. A diferencia del antiguo "Símbolo del sistema" (cmd), PowerShell ofrece comandos más potentes y una mejor integración con herramientas modernas como Docker. Aprender a usar la terminal es una habilidad esencial para cualquier desarrollador o administrador de sistemas, ya que muchas operaciones son más rápidas y precisas por línea de comandos que a través de interfaces gráficas.

**Sigue estos pasos para abrir PowerShell:**

1. Presiona `Windows + X` (mantén presionada la tecla Windows y luego presiona X)
2. En el menú que aparece, selecciona **Windows PowerShell** o **Terminal**
3. Se abrirá una ventana de línea de comandos con fondo azul oscuro

Por defecto, PowerShell se abre en tu directorio de usuario:
```
PS C:\Users\TuNombre>
```

### 1.2 Comprobar la instalación de Docker

El primer paso de nuestra verificación consiste en confirmar que Docker está instalado en tu sistema. Cuando instalas Docker Desktop en Windows, se añade el comando `docker` a tu sistema, permitiéndote interactuar con la plataforma desde cualquier terminal. Si Docker no está instalado, el sistema no reconocerá el comando y mostrará un error. Esta verificación es rápida pero crucial: sin Docker instalado, ninguno de los pasos siguientes funcionará.

**Ejecuta el siguiente comando** (escríbelo exactamente como aparece y presiona Enter):

```powershell
docker --version
```

**¿Qué hace este comando?**  
Solicita a Docker que muestre su versión instalada. Si Docker está correctamente instalado, responderá con información de versión.

**Salida esperada:**
```
Docker version 24.0.x, build xxxxxxx
```

**Si ves un error como `docker: command not found` o `docker no se reconoce como comando`:**
- Docker no está instalado, o
- Docker no está en el PATH del sistema

**Solución:** Instala Docker Desktop desde https://www.docker.com/products/docker-desktop

### 1.3 Verificar que el demonio Docker está corriendo

Docker funciona con una arquitectura cliente-servidor. El **demonio** (también llamado "daemon" en inglés) es un proceso que se ejecuta silenciosamente en segundo plano de tu computadora, esperando instrucciones. Cuando escribes un comando como `docker run`, el cliente (la terminal) envía esa instrucción al demonio, que es quien realmente crea y ejecuta los contenedores. Es como un restaurante: tú (el cliente) haces el pedido al mesero (el comando), pero es el chef (el demonio) quien prepara la comida. Sin el chef, no hay comida; sin el demonio, no hay contenedores.

**Ejecuta el siguiente comando para verificar el estado del demonio:**

```powershell
docker info
```

**¿Qué hace este comando?**  
Muestra información detallada del sistema Docker: número de contenedores, imágenes almacenadas, driver de almacenamiento, versión del kernel, etc.

**Si ves el error `Cannot connect to the Docker daemon`:**

1. Busca el icono de Docker (una ballena) en la barra de tareas de Windows
2. Si no está, busca "Docker Desktop" en el menú inicio y ábrelo
3. Espera a que el icono muestre "Docker Desktop is running"
4. Vuelve a ejecutar `docker info`

### 1.4 Ejecutar contenedor de prueba

Ahora que hemos verificado que Docker está instalado y el demonio está corriendo, realizaremos la prueba definitiva: ejecutar un contenedor real. Docker proporciona una imagen especial llamada `hello-world` diseñada específicamente para esta verificación. Esta imagen es extremadamente pequeña (unos pocos kilobytes) y su única función es imprimir un mensaje de confirmación. Si este contenedor se ejecuta correctamente, significa que toda la cadena de Docker funciona: descarga de imágenes, creación de contenedores, ejecución y comunicación con el demonio.

**Ejecuta el siguiente comando:**

```powershell
docker run hello-world
```

**¿Qué hace este comando?**  
1. Busca la imagen `hello-world` en tu máquina local
2. Al no encontrarla, la descarga desde Docker Hub (repositorio en internet)
3. Crea un contenedor a partir de esa imagen
4. Ejecuta el contenedor, que imprime un mensaje
5. El contenedor termina automáticamente

**Salida esperada (fragmento):**
```
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
...
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

Si ves `Hello from Docker!`, tu entorno está correctamente configurado.



## **Paso 2: Fundamentos de Docker**

Antes de sumergirnos en el uso práctico de Apache con Docker, es esencial que comprendas cómo funciona Docker internamente. Muchos estudiantes cometen el error de saltar directamente a ejecutar comandos sin entender qué están haciendo, lo que genera confusión cuando algo no funciona como esperaban. Docker revolucionó la forma en que desarrollamos y desplegamos software al introducir el concepto de "contenedores": entornos ligeros y aislados que contienen todo lo necesario para ejecutar una aplicación. En este paso, exploraremos la arquitectura de Docker, los conceptos fundamentales que necesitas dominar (imágenes, contenedores, volúmenes y puertos), y los comandos esenciales que usarás constantemente. No te apresures en esta sección: una buena comprensión de estos fundamentos te ahorrará horas de frustración más adelante.

### 2.1 Arquitectura de Docker

Para usar Docker efectivamente, primero debes entender su arquitectura básica. Docker utiliza un modelo cliente-servidor que separa la interfaz de usuario (lo que tú usas) del motor que realmente hace el trabajo. Esta separación permite que Docker sea flexible y potente, permitiendo incluso que el demonio se ejecute en una máquina diferente a la del cliente. Comprender esta arquitectura te ayudará a diagnosticar problemas cuando algo no funcione correctamente.

Docker utiliza una arquitectura **cliente-servidor**:

```
┌─────────────────────────────────────────────────────────────┐
│                    TU COMPUTADORA (Windows)                 │
│                                                             │
│  ┌─────────────┐         ┌────────────────────────────┐     │
│  │   Cliente   │         │      Docker Daemon         │     │
│  │   (CLI)     │────────►│   (proceso en segundo      │     │
│  │             │         │    plano que ejecuta       │     │
│  │ Tú escribes │         │    los contenedores)       │     │
│  │ comandos    │         │                            │     │
│  │ aquí        │         │  ┌──────┐  ┌──────┐        │     │
│  └─────────────┘         │  │ Cont │  │ Cont │        │     │
│                          │  │  1   │  │  2   │        │     │
│                          │  └──────┘  └──────┘        │     │
│                          └────────────────────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

- **Cliente (CLI):** Es lo que usas cuando escribes `docker run`, `docker ps`, etc.
- **Daemon:** Es el servicio que realmente crea y ejecuta los contenedores.

### 2.2 Conceptos fundamentales

Hay cuatro conceptos que son absolutamente esenciales para trabajar con Docker. Estos conceptos aparecerán una y otra vez a lo largo de este tutorial y de tu carrera trabajando con contenedores. Tómate el tiempo necesario para comprender cada uno de ellos, ya que forman la base de todo lo que harás con Docker. No te preocupes si al principio parecen abstractos; a medida que los uses en la práctica, se volverán intuitivos.

#### Imagen (Image)
Una **imagen** es una plantilla de solo lectura. Contiene:
- Un sistema operativo base (ej: Debian, Alpine Linux)
- Software instalado (ej: Apache)
- Archivos de configuración
- Tu aplicación

**Analogía:** Una imagen es como un molde de galletas. Puedes hacer muchas galletas (contenedores) del mismo molde (imagen).

#### Contenedor (Container)
Un **contenedor** es una instancia en ejecución de una imagen. Es un proceso aislado con:
- Su propio sistema de archivos
- Su propia red
- Sus propios procesos

**Importante:** Los contenedores son **efímeros**. Cuando los eliminas, se pierde todo lo que había dentro (a menos que uses volúmenes).

#### Volumen (Volume)
Un **volumen** es un mecanismo para que los datos persistan fuera del contenedor. Es una carpeta en tu computadora que se "conecta" al contenedor.

#### Puerto (Port)
Los contenedores tienen su propia red aislada. Para acceder a un servicio dentro del contenedor desde tu navegador, debes **mapear puertos**.

### 2.3 Comandos esenciales de Docker

Ahora que comprendes los conceptos, es hora de aprender los comandos que te permitirán interactuar con Docker. Estos comandos serán tus herramientas principales durante todo el tutorial. No necesitas memorizarlos todos ahora mismo; esta tabla te servirá como referencia rápida. Con la práctica, los comandos más comunes se volverán automáticos.

| Comando | ¿Qué hace? |
|---------|------------|
| `docker pull <imagen>` | Descarga una imagen desde Docker Hub |
| `docker images` | Lista las imágenes que tienes descargadas |
| `docker run <imagen>` | Crea y ejecuta un contenedor |
| `docker ps` | Lista contenedores que están corriendo ahora |
| `docker ps -a` | Lista TODOS los contenedores (incluso los detenidos) |
| `docker stop <nombre>` | Detiene un contenedor |
| `docker start <nombre>` | Inicia un contenedor que estaba detenido |
| `docker rm <nombre>` | Elimina un contenedor |
| `docker rmi <imagen>` | Elimina una imagen |
| `docker logs <nombre>` | Muestra los logs de un contenedor |
| `docker exec -it <nombre> bash` | Entra dentro de un contenedor |

## **Paso 3: Apache HTTP Server - Conceptos**

Ahora que dominas los fundamentos de Docker, es momento de conocer la aplicación que vamos a contenerizar: Apache HTTP Server. Apache es uno de los servidores web más utilizados del mundo, sirviendo millones de sitios web desde su creación en 1995. Aunque hoy existen alternativas como Nginx, Apache sigue siendo extremadamente popular debido a su robustez, flexibilidad y extensa documentación. Entender cómo funciona Apache te dará una base sólida para comprender cualquier servidor web. En este paso aprenderemos qué es Apache, cómo procesa las peticiones web, por qué usar Docker simplifica enormemente su despliegue, y cómo está organizada su estructura de directorios. Este conocimiento teórico te permitirá entender por qué hacemos lo que hacemos en los pasos prácticos.

### 3.1 ¿Qué es Apache HTTP Server?

Apache HTTP Server (conocido también como "httpd" o simplemente "Apache") es un software que convierte tu computadora en un servidor web. Su función principal es recibir peticiones de navegadores web, buscar los archivos solicitados (HTML, CSS, imágenes, etc.) y devolverlos al navegador para que pueda mostrarlos. Es el intermediario entre tus archivos y los usuarios que visitan tu sitio web.

Apache HTTP Server (también conocido como **httpd**) es un servidor web. Su trabajo es:

```
┌──────────────┐         ┌──────────────────┐         ┌──────────────┐
│  Navegador   │         │  Apache HTTP     │         │  Archivos    │
│  (Chrome,    │──HTTP──►│  Server          │────────►│  HTML, CSS,  │
│   Firefox)   │◄────────│                  │◄────────│  JS, imgs    │
│              │  HTML   │  Puerto 80       │         │              │
└──────────────┘         └──────────────────┘         └──────────────┘
```

1. Tu navegador envía una petición HTTP (ej: "quiero la página index.html")
2. Apache recibe la petición
3. Apache busca el archivo en el sistema de archivos
4. Apache devuelve el archivo al navegador
5. El navegador renderiza la página

### 3.2 ¿Por qué usar Apache con Docker?

Podrías preguntarte: "¿Por qué usar Docker si puedo instalar Apache directamente en Windows?" La respuesta corta es: Docker hace todo más simple, limpio y reproducible. La respuesta larga involucra entender los dolores de cabeza que Docker te ahorra: conflictos con otros programas, instalaciones complicadas, configuraciones que varían entre sistemas, y la dificultad de desinstalar completamente un software.

| Sin Docker | Con Docker |
|------------|------------|
| Instalar Apache en Windows es complejo | Un solo comando descarga y ejecuta Apache |
| Puede entrar en conflicto con otros programas | Cada contenedor está aislado |
| Difícil de desinstalar completamente | `docker rm` y desaparece |
| Configuración varía según SO | Mismo comportamiento en cualquier máquina |

### 3.3 Estructura de directorios de Apache (dentro del contenedor)

Antes de ejecutar Apache en Docker, es muy importante que entiendas cómo está organizado Apache internamente. Cuando ejecutes un contenedor con Apache, dentro de él existirá toda una estructura de carpetas y archivos. Conocer esta estructura te permitirá saber dónde colocar tus archivos web, dónde encontrar los logs cuando algo falle, y dónde modificar la configuración. Mira este diagrama y familiarízate con él:

```
/usr/local/apache2/
├── bin/                    # Ejecutables (httpd, apachectl)
│   └── httpd               # El programa principal de Apache
├── conf/
│   ├── httpd.conf          # ARCHIVO DE CONFIGURACIÓN PRINCIPAL
│   ├── mime.types          # Tipos de archivo
│   └── extra/              # Configuraciones adicionales
├── htdocs/                 # ← AQUÍ VAN TUS ARCHIVOS WEB
│   └── index.html          # Página por defecto
├── logs/                   # Registros de acceso y errores
└── modules/                # Módulos de Apache (.so)
```

**Lo más importante:**
- `/usr/local/apache2/htdocs/` → Es donde Apache busca los archivos web
- `/usr/local/apache2/conf/httpd.conf` → Es el archivo de configuración

## **Paso 4: Descargar la imagen de Apache**

Llega el momento de pasar de la teoría a la práctica. En este paso descargaremos la imagen oficial de Apache desde Docker Hub, que es el repositorio público de imágenes Docker más grande del mundo. Piensa en Docker Hub como una tienda de aplicaciones, pero en lugar de descargar apps para tu teléfono, descargas imágenes de contenedores listas para usar. La imagen de Apache que descargaremos contiene un sistema operativo Linux mínimo con Apache ya instalado y configurado. Una vez descargada, esta imagen quedará almacenada en tu computadora y podrás crear tantos contenedores como necesites a partir de ella. Este proceso de descarga solo necesitas hacerlo una vez; después, Docker reutilizará la imagen local sin necesidad de volver a descargarla.

### 4.1 ¿Qué vamos a hacer?

Antes de ejecutar cualquier comando, es importante que entiendas el objetivo de esta sección. Vamos a descargar (en terminología Docker, "pull") la imagen oficial de Apache desde Docker Hub a tu computadora local. Una vez completada la descarga, la imagen estará disponible para crear contenedores. Este proceso es similar a descargar un instalador de software, con la diferencia de que la imagen ya contiene todo configurado y listo para ejecutar.

### 4.2 Ejecutar el comando de descarga

Ahora ejecutaremos el comando que descarga la imagen de Apache. Es un comando simple pero muy potente: con una sola línea, Docker contactará los servidores de Docker Hub, buscará la imagen solicitada, verificará que sea auténtica e iniciará la descarga. La imagen se divide en "capas" que se descargan una por una, lo que permite reutilizar capas comunes entre diferentes imágenes.

**Abre PowerShell y ejecuta el siguiente comando:**

```powershell
docker pull httpd:2.4
```

**Desglose del comando:**

| Parte | Significado |
|-------|-------------|
| `docker pull` | Comando para descargar una imagen |
| `httpd` | Nombre de la imagen (httpd = Apache HTTP Server) |
| `:2.4` | Tag/versión de la imagen (versión 2.4 de Apache) |

**¿Por qué especificar la versión?**  
Si no especificas versión, Docker descarga `latest` (la última). Esto puede causar problemas porque `latest` cambia con el tiempo. Especificar `2.4` garantiza reproducibilidad.

**Salida esperada:**
```
2.4: Pulling from library/httpd
a2abf6c4d29d: Pull complete
dcc4698797c8: Pull complete
41c22baa66ec: Pull complete
67283bbdd4a0: Pull complete
d982c879c57e: Pull complete
Digest: sha256:a182ef2350699f04b8f8...
Status: Downloaded newer image for httpd:2.4
docker.io/library/httpd:2.4
```

Cada línea `Pull complete` es una **capa** de la imagen que se descarga.

### 4.3 Verificar que la imagen se descargó

Siempre es una buena práctica verificar que las operaciones se completaron correctamente. Este comando te mostrará todas las imágenes que tienes almacenadas localmente en tu computadora, incluyendo el tamaño de cada una y cuándo fueron creadas. Verás la imagen `httpd:2.4` que acabamos de descargar.

**Ejecuta el siguiente comando:**

```powershell
docker images
```

**Salida esperada:**
```
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
httpd         2.4       a182ef235069   2 weeks ago    148MB
hello-world   latest    d2c94e258dcb   9 months ago   13.3kB
```

La imagen `httpd:2.4` ahora está en tu máquina local. No necesitas volver a descargarla.

### 4.4 Inspeccionar la imagen (opcional)

Si tienes curiosidad por saber más sobre la imagen que acabas de descargar, Docker te permite inspeccionarla en detalle. El comando `docker inspect` muestra un archivo JSON con toda la información técnica de la imagen: qué puertos expone, qué comando ejecuta por defecto, variables de entorno, y mucho más. Este comando es opcional pero muy útil cuando necesitas entender cómo está configurada una imagen.

```powershell
docker inspect httpd:2.4
```

Esto muestra un JSON extenso. Información relevante:
- `Config.ExposedPorts`: Puertos que expone (80/tcp)
- `Config.Cmd`: Comando que ejecuta por defecto (`httpd-foreground`)



## **Paso 5: Ejecutar el primer contenedor Apache**

¡Felicidades por llegar hasta aquí! Este es el momento más emocionante del tutorial: vamos a poner Apache en funcionamiento. En este paso crearemos tu primer contenedor de servidor web, configuraremos el acceso desde tu navegador y comprobaremos que todo funciona correctamente. Es importante que entiendas que un contenedor es diferente a una instalación tradicional: el contenedor está completamente aislado del resto de tu sistema, lo que significa que puedes experimentar sin miedo a romper nada. Si algo sale mal, simplemente eliminas el contenedor y empiezas de nuevo. Esta libertad para experimentar es una de las mayores ventajas de Docker. Prepárate para ver Apache en acción en tu propio navegador.

### 5.1 ¿Qué vamos a hacer?

En esta sección crearás un contenedor a partir de la imagen `httpd:2.4` que descargaste anteriormente. Configuraremos el contenedor para que Apache sea accesible desde tu navegador web. Esto involucra un concepto importante llamado "mapeo de puertos", que explicaremos en detalle. Al final de esta sección, podrás abrir tu navegador, ir a una dirección local, y ver la página de bienvenida de Apache.

### 5.2 El comando completo

Este es el comando que usaremos para crear y ejecutar el contenedor. Puede parecer largo, pero cada parte tiene un propósito importante que explicaremos en detalle. Primero ejecútalo, observa el resultado, y luego estudiaremos cada componente:

```powershell
docker run -d --name apache-basico -p 8080:80 httpd:2.4
```

### 5.3 Explicación detallada de cada parte

Ahora que el contenedor está ejecutándose, tomemos un momento para entender exactamente qué hace cada parte del comando. Esta comprensión es crucial porque usarás variaciones de este comando constantemente cuando trabajes con Docker. No memorices el comando a ciegas; entiende cada pieza para poder adaptarlo a tus necesidades.

| Parámetro | ¿Qué hace? | ¿Por qué es necesario? |
|-----------|------------|------------------------|
| `docker run` | Crea y ejecuta un contenedor | Comando base |
| `-d` | Modo "detached" (segundo plano) | Sin esto, la terminal queda bloqueada mostrando logs |
| `--name apache-basico` | Asigna el nombre "apache-basico" | Sin esto, Docker genera nombres aleatorios como "angry_newton" |
| `-p 8080:80` | Mapea puerto 8080 (tu PC) al puerto 80 (contenedor) | Sin esto, no podrías acceder a Apache desde el navegador |
| `httpd:2.4` | La imagen a usar | Le dice a Docker qué software ejecutar |

### 5.4 Entendiendo el mapeo de puertos

El mapeo de puertos es probablemente el concepto más importante cuando trabajas con contenedores que ofrecen servicios de red. Los contenedores están aislados por defecto: aunque Apache dentro del contenedor escucha en el puerto 80, tu computadora no puede "ver" ese puerto directamente. El parámetro `-p 8080:80` crea un "túnel" que conecta el puerto 8080 de tu computadora con el puerto 80 del contenedor.

```
    TU PC (Windows)                     CONTENEDOR
    ───────────────                     ──────────
                                        
    localhost:8080  ◄─────────────────► Puerto 80
         │                                  │
         │          -p 8080:80              │
         │                                  │
    Tu navegador                       Apache httpd
    accede aquí                        escucha aquí
```

**¿Por qué no usar el puerto 80 directamente?**
- En Windows, el puerto 80 puede estar ocupado por otros servicios
- El puerto 8080 es comúnmente usado para desarrollo
- Puedes tener múltiples contenedores en diferentes puertos (8080, 8081, 8082...)

### 5.5 Verificar que el contenedor está corriendo

Siempre que inicies un contenedor, es buena práctica verificar que realmente está funcionando. El comando `docker ps` (de "process status") muestra todos los contenedores que están actualmente en ejecución. Aprender a leer su salida es esencial para administrar tus contenedores.

```powershell
docker ps
```

**Salida esperada:**
```
CONTAINER ID   IMAGE       COMMAND              CREATED          STATUS          PORTS                  NAMES
a1b2c3d4e5f6   httpd:2.4   "httpd-foreground"   10 seconds ago   Up 9 seconds    0.0.0.0:8080->80/tcp   apache-basico
```

**Interpretación de cada columna:**

| Columna | Significado |
|---------|-------------|
| `CONTAINER ID` | Identificador único (puedes usar los primeros caracteres) |
| `IMAGE` | Imagen de la que se creó |
| `COMMAND` | Comando que está ejecutando |
| `CREATED` | Cuándo se creó |
| `STATUS` | Estado actual (`Up` = corriendo) |
| `PORTS` | Mapeo de puertos |
| `NAMES` | Nombre del contenedor |

### 5.6 Probar que Apache funciona

Llegó el momento de la verdad: vamos a comprobar que Apache realmente está sirviendo páginas web. Hay dos formas de hacerlo: usando tu navegador web favorito (la forma más visual y satisfactoria) o usando la terminal (la forma más rápida y automatizable). Te recomiendo probar ambas para familiarizarte con las opciones disponibles.

**Opción 1: Desde el navegador (recomendada para principiantes)**

1. Abre Chrome, Firefox, Edge o cualquier navegador
2. En la barra de direcciones, escribe: `http://localhost:8080`
3. Presiona Enter

**Opción 2: Desde PowerShell**

```powershell
curl http://localhost:8080
```

O con el cmdlet nativo de PowerShell:

```powershell
Invoke-WebRequest -Uri http://localhost:8080 | Select-Object -ExpandProperty Content
```

**Salida esperada:**
```html
<html><body><h1>It works!</h1></body></html>
```

Este es el archivo `index.html` por defecto que viene con Apache.

## **Paso 6: Gestión del contenedor**

Ahora que tienes Apache funcionando en un contenedor, es esencial que aprendas a administrarlo correctamente. Un administrador de sistemas o desarrollador competente no solo sabe cómo iniciar servicios, sino también cómo monitorizarlos, diagnosticar problemas, y realizar operaciones de mantenimiento. En esta sección aprenderás a ver los logs (registros) que genera Apache, a "entrar" dentro del contenedor para explorarlo, y a controlar su ciclo de vida (detener, reiniciar, eliminar). Estas habilidades son transferibles a cualquier contenedor Docker, no solo a Apache. Domínalas bien, porque las usarás constantemente en tu trabajo con contenedores. Piensa en esta sección como el "panel de control" de tu contenedor.

### 6.1 Ver los logs del servidor

Los **logs** son como el diario del servidor: registran todo lo que sucede, incluyendo quién accede a tus páginas, errores que ocurren, y el estado general del servicio. Saber leer logs es una habilidad fundamental para cualquier persona que trabaje con servidores. Cuando algo no funciona, los logs son el primer lugar donde buscar pistas. Apache genera dos tipos de logs: accesos (¿quién visitó qué?) y errores (¿qué falló?).

**Ejecuta el siguiente comando para ver los logs:**

```powershell
docker logs apache-basico
```

**Salida típica:**
```
AH00558: httpd: Could not reliably determine the server's fully qualified domain name
[Mon Jan 15 10:00:00.000000 2024] [mpm_event:notice] [pid 1:tid 1] AH00489: Apache/2.4.58 (Unix) configured -- resuming normal operations
[Mon Jan 15 10:00:00.000001 2024] [core:notice] [pid 1:tid 1] AH00094: Command line: 'httpd -D FOREGROUND'
172.17.0.1 - - [15/Jan/2024:10:00:05 +0000] "GET / HTTP/1.1" 200 45
```

**Interpretación:**
- `AH00558`: Advertencia menor (puedes ignorarla)
- `Apache/2.4.58 configured -- resuming normal operations`: Apache inició correctamente
- `172.17.0.1 - - [...] "GET / HTTP/1.1" 200 45`: Alguien (tú) accedió a la página principal

**Para seguir los logs en tiempo real:**

```powershell
docker logs -f apache-basico
```

El flag `-f` (follow) hace que los nuevos logs aparezcan automáticamente. Presiona `Ctrl+C` para salir.

### 6.2 Entrar dentro del contenedor

Una de las características más poderosas de Docker es la capacidad de "entrar" en un contenedor mientras está ejecutándose. Esto te permite explorar su sistema de archivos, ejecutar comandos de diagnóstico, verificar configuraciones, o simplemente curiosear cómo está estructurado internamente. Es como tener acceso remoto a un servidor, pero ese "servidor" es tu contenedor local. Esta habilidad es invaluable para debugging y aprendizaje.

**Ejecuta el siguiente comando para entrar al contenedor:**

```powershell
docker exec -it apache-basico bash
```

**Desglose:**

| Parte | Significado |
|-------|-------------|
| `docker exec` | Ejecuta un comando en un contenedor existente |
| `-i` | Modo interactivo (mantiene STDIN abierto) |
| `-t` | Asigna una pseudo-terminal |
| `apache-basico` | Nombre del contenedor |
| `bash` | El comando a ejecutar (el shell bash) |

**Ahora estás DENTRO del contenedor.** El prompt cambiará a algo como:
```
root@a1b2c3d4e5f6:/usr/local/apache2#
```

**Comandos para explorar dentro del contenedor:**

```bash
# Ver en qué directorio estás
pwd
# Salida: /usr/local/apache2

# Ver la versión de Apache
httpd -v
# Salida: Server version: Apache/2.4.58 (Unix)

# Ver el contenido del directorio web
ls -la htdocs/
# Salida: index.html

# Ver el contenido del archivo index.html
cat htdocs/index.html
# Salida: <html><body><h1>It works!</h1></body></html>

# Ver el archivo de configuración (las primeras 20 líneas)
head -20 conf/httpd.conf

# Salir del contenedor (IMPORTANTE)
exit
```

**Importante:** Cuando escribes `exit`, sales del contenedor pero el contenedor sigue corriendo.

### 6.3 Ciclo de vida del contenedor

Los contenedores tienen un ciclo de vida bien definido que debes entender. A diferencia de los programas tradicionales que simplemente "abres" y "cierras", los contenedores pueden estar en diferentes estados y puedes transicionar entre ellos. Comprender este ciclo te ayudará a saber qué comando usar en cada situación y a evitar errores comunes como intentar eliminar un contenedor que está corriendo.

```
   docker run              docker stop             docker start
       │                       │                        │
       ▼                       ▼                        ▼
  ┌─────────┐            ┌──────────┐            ┌──────────┐
  │ RUNNING │───────────►│ STOPPED  │───────────►│ RUNNING  │
  │         │            │          │            │          │
  └─────────┘            └──────────┘            └──────────┘
       │                       │
       │                       │ docker rm
       │                       ▼
       │                 ┌──────────┐
       └────────────────►│ DELETED  │
         docker rm -f    └──────────┘
```

### 6.4 Comandos de control

Aquí tienes los comandos esenciales para controlar el ciclo de vida de tus contenedores. Practícalos ahora con tu contenedor `apache-basico`. No tengas miedo de detener y reiniciar el contenedor; es la mejor manera de aprender cómo funcionan estos comandos. Recuerda que el contenedor mantiene su estado y configuración mientras exista (aunque esté detenido).

**Detener el contenedor:**
```powershell
docker stop apache-basico
```
Esto envía una señal SIGTERM a Apache, permitiendo que se cierre correctamente.

**Verificar que está detenido:**
```powershell
docker ps -a
```
El STATUS mostrará `Exited (0)`.

**Iniciar el contenedor detenido:**
```powershell
docker start apache-basico
```

**Reiniciar el contenedor:**
```powershell
docker restart apache-basico
```

**Eliminar el contenedor (primero debe estar detenido):**
```powershell
docker stop apache-basico
docker rm apache-basico
```

**Eliminar el contenedor forzadamente (aunque esté corriendo):**
```powershell
docker rm -f apache-basico
```

## **Paso 7: Montar volúmenes - Servir contenido propio**

Hasta ahora has ejecutado Apache con su contenido por defecto: una simple página que dice "It works!". Pero el objetivo real es servir TUS propias páginas web, TU propio HTML, CSS, imágenes, etc. En este paso aprenderás una de las características más potentes de Docker: los volúmenes. Los volúmenes permiten "conectar" una carpeta de tu computadora Windows con una carpeta dentro del contenedor. Esto significa que podrás editar tus archivos cómodamente en Windows usando tu editor favorito (VS Code, Notepad++, o cualquier otro), y Apache dentro del contenedor los verá instantáneamente. Además, tus archivos permanecerán seguros en tu disco duro incluso si eliminas el contenedor. Esta sección es fundamental para cualquier trabajo de desarrollo web con Docker.

### 7.1 El problema actual

Antes de introduir la solución, es importante que entiendas claramente cuál es el problema. Actualmente, cuando accedes a Apache en tu navegador, ves una página genérica. Esa página existe DENTRO del contenedor, lo que presenta varios inconvenientes prácticos para el desarrollo web.

Hasta ahora, cuando accedes a `http://localhost:8080`, Apache muestra:

```html
<html><body><h1>It works!</h1></body></html>
```

Este es el archivo `index.html` que viene **dentro del contenedor** por defecto. El problema es:

- Si quieres mostrar TU página web, tendrías que entrar al contenedor y editar archivos ahí
- Si eliminas el contenedor, **pierdes todo tu trabajo**
- No puedes usar editores de Windows como VS Code para editar archivos dentro del contenedor

### 7.2 La solución: Volúmenes

Los volúmenes solucionan todos los problemas mencionados anteriormente. Un **volumen** crea un "puente" entre tu sistema de archivos de Windows y el sistema de archivos del contenedor. Los cambios en un lado se reflejan instantáneamente en el otro. Es bidireccional: tú editas en Windows, el contenedor ve los cambios; si algo modifica archivos en el contenedor, tú los verías en Windows.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│   TU PC WINDOWS                              CONTENEDOR DOCKER              │
│   ══════════════                             ═════════════════              │
│                                                                             │
│   C:\mi-sitio-web\                          /usr/local/apache2/htdocs/      │
│   ├── index.html    ◄═══════════════════════► ├── index.html                │
│   ├── styles.css    ◄═══ SINCRONIZADO ══════► ├── styles.css                │
│   └── imagenes\     ◄═══════════════════════► └── imagenes\                 │
│                                                                             │
│   Tú editas aquí                             Apache lee desde aquí          │
│   con VS Code,                               y sirve las páginas            │
│   Notepad++, etc.                            al navegador                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**¿Qué significa esto?**
- Los archivos existen FÍSICAMENTE en tu disco duro de Windows
- El contenedor Docker puede LEER esos archivos como si estuvieran dentro de él
- Cuando modificas un archivo en Windows, Apache lo ve inmediatamente
- Si eliminas el contenedor, tus archivos siguen existiendo en Windows

### 7.3 Entendiendo el sistema de archivos de Windows

Antes de crear carpetas para nuestro proyecto, debemos asegurarnos de que entiendes cómo funciona el sistema de archivos de Windows. Si vienes de Linux o Mac, o si simplemente nunca has pensado en esto, esta explicación te será muy útil. Windows organiza sus archivos de manera jerárquica, usando "unidades" identificadas por letras (C:, D:, etc.). Conocer esta estructura te ayudará a decidir dónde crear tu proyecto.

**En Windows, los discos se identifican con letras:**

```
C:\                         ← Disco principal (donde está Windows)
├── Windows\                ← Sistema operativo (NO TOCAR)
├── Program Files\          ← Programas instalados
├── Users\                  ← Carpetas de usuarios
│   └── TuNombre\           ← Tu carpeta personal
│       ├── Desktop\        ← Escritorio
│       ├── Documents\      ← Documentos
│       └── Downloads\      ← Descargas
└── ...

D:\                         ← Disco secundario (si tienes uno)
```

**Importante:** 
- `C:\` es la RAÍZ del disco C. Es el nivel más alto.
- `C:\Users\TuNombre\` es tu carpeta personal.
- Puedes crear proyectos en cualquier lugar donde tengas permisos.

### 7.4 Decidir DÓNDE crear el proyecto

Elegir la ubicación correcta para tu proyecto es una decisión importante. Afecta la facilidad con la que podrás acceder a tus archivos, la longitud de los comandos que escribirás, y potencialmente los permisos necesarios. A continuación te presentamos las opciones más comunes con sus ventajas y desventajas para que tomes una decisión informada.

| Ubicación | Ruta ejemplo | Ventajas | Desventajas |
|-----------|--------------|----------|-------------|
| Raíz de C: | `C:\apache-proyecto` | Ruta corta, fácil de escribir | Requiere permisos de admin a veces |
| Documentos | `C:\Users\TuNombre\Documents\apache-proyecto` | Tu espacio personal | Ruta muy larga |
| Escritorio | `C:\Users\TuNombre\Desktop\apache-proyecto` | Visible, fácil acceso | Ruta larga |
| Disco D: | `D:\proyectos\apache-proyecto` | Separado del sistema | No todos tienen disco D |

**En este tutorial usaremos:** `C:\apache-proyecto`

Elegimos esta ubicación porque:
1. La ruta es corta y fácil de escribir
2. Es fácil de encontrar en el Explorador de Windows
3. Funciona en cualquier computadora con Windows

**Si prefieres otra ubicación**, simplemente reemplaza `C:\apache-proyecto` por tu ruta preferida en todos los comandos.

### 7.5 Crear la estructura del proyecto

Ahora sí, manos a la obra. Vamos a crear las carpetas necesarias para nuestro proyecto. Te ofrecemos DOS opciones: una visual (usando el Explorador de Windows) y otra por comandos (usando PowerShell). Ambas logran exactamente el mismo resultado. Si eres nuevo en la línea de comandos, prueba primero la opción visual para entender qué estamos creando, y luego la opción por comandos para practicar PowerShell.

#### OPCIÓN A: Crear carpetas con el Explorador de Windows (método visual)

**Paso 1:** Abrir el Explorador de Windows
- Presiona `Windows + E` en tu teclado
- O haz clic en el icono de carpeta en la barra de tareas

**Paso 2:** Navegar al disco C:
- En el panel izquierdo, haz clic en "Este equipo" o "This PC"
- Luego haz doble clic en "Disco local (C:)" o "Local Disk (C:)"

```
┌──────────────────────────────────────────────────────────────────┐
│  ← → ↑  │ Este equipo > Disco local (C:)                         │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  📁 Program Files                                                 │
│  📁 Program Files (x86)                                           │
│  📁 Users                                                         │
│  📁 Windows                                                       │
│                                                                  │
│         ↑                                                        │
│         │  Estás viendo el contenido de C:\                      │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

**Paso 3:** Crear la carpeta del proyecto
- Clic derecho en un espacio vacío
- Selecciona "Nuevo" → "Carpeta"
- Escribe el nombre: `apache-proyecto`
- Presiona Enter

**Paso 4:** Entrar a la carpeta y crear la subcarpeta
- Haz doble clic en `apache-proyecto` para entrar
- Clic derecho → "Nuevo" → "Carpeta"
- Escribe el nombre: `htdocs`
- Presiona Enter

**Resultado:** Has creado esta estructura:
```
C:\
└── apache-proyecto\
    └── htdocs\
```

#### OPCIÓN B: Crear carpetas con PowerShell (método por comandos)

**Paso 1:** Abrir PowerShell

1. Presiona `Windows + X`
2. Selecciona "Windows PowerShell" o "Terminal"

Verás algo como:
```
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\TuNombre>
```

El texto `PS C:\Users\TuNombre>` es el **prompt**. Te indica:
- `PS` = PowerShell
- `C:\Users\TuNombre` = El directorio donde estás actualmente
- `>` = Aquí escribes comandos

**Paso 2:** Crear la carpeta principal

Escribe este comando y presiona Enter:

```powershell
New-Item -ItemType Directory -Path C:\apache-proyecto -Force
```

**¿Qué significa cada parte?**

| Parte | Significado |
|-------|-------------|
| `New-Item` | Comando de PowerShell para crear algo nuevo |
| `-ItemType Directory` | Indica que queremos crear una carpeta (no un archivo) |
| `-Path C:\apache-proyecto` | La ruta completa donde crear la carpeta |
| `-Force` | Si ya existe, no mostrar error |

**Salida esperada:**

```
    Directory: C:\

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        15/01/2024     10:30                apache-proyecto
```

Esto confirma que se creó la carpeta `apache-proyecto` dentro de `C:\`.

**Paso 3:** Crear la subcarpeta htdocs

```powershell
New-Item -ItemType Directory -Path C:\apache-proyecto\htdocs -Force
```

**Salida esperada:**

```
    Directory: C:\apache-proyecto

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        15/01/2024     10:30                htdocs
```

Esto confirma que se creó la carpeta `htdocs` dentro de `C:\apache-proyecto`.

### 7.6 Verificar que las carpetas existen

Es una excelente práctica verificar que las operaciones se completaron correctamente antes de continuar. Esto te evitará problemas más adelante y te ayudará a desarrollar buenos hábitos de trabajo. Vamos a comprobar que las carpetas se crearon donde esperamos.

**Verificación con PowerShell:**

```powershell
Get-ChildItem C:\apache-proyecto
```

**Salida esperada:**

```
    Directory: C:\apache-proyecto

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        15/01/2024     10:30                htdocs
```

Si ves `htdocs` en la lista, las carpetas están correctas.

**Verificación con el Explorador de Windows:**

1. Presiona `Windows + E`
2. En la barra de direcciones (arriba), escribe: `C:\apache-proyecto`
3. Presiona Enter

```
┌──────────────────────────────────────────────────────────────────┐
│  ← → ↑  │ C:\apache-proyecto                                     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  📁 htdocs                                                        │
│                                                                  │
│         ↑                                                        │
│         │  Deberías ver la carpeta htdocs aquí                   │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### 7.7 Estructura del proyecto explicada

Antes de continuar, asegurémonos de que comprendes la estructura que acabamos de crear. Esta comprensión es fundamental porque la usarás repetidamente en proyectos futuros. La estructura es simple pero sigue una convención muy común en el mundo del desarrollo web.

Ahora tienes esta estructura en tu disco:

```
C:\                                    ← Raíz del disco C de Windows
└── apache-proyecto\                   ← Carpeta de tu proyecto
    └── htdocs\                        ← Aquí van los archivos web
        └── (vacía por ahora)             (HTML, CSS, JS, imágenes)
```

**¿Por qué esta estructura?**

- `apache-proyecto\` → Es la carpeta "contenedora" de todo tu proyecto
- `htdocs\` → Es donde irán los archivos que Apache servirá

El nombre `htdocs` viene de "HyperText Documents" y es el nombre tradicional que Apache usa para la carpeta de documentos web.

### 7.8 Relación entre Windows y el contenedor

Este es un concepto clave que debes visualizar claramente. Cuando ejecutes el contenedor con un volumen montado, estarás "conectando" dos mundos: tu sistema de archivos de Windows y el sistema de archivos Linux del contenedor. Cualquier cambio en uno se refleja en el otro instantáneamente.

Cuando ejecutes el contenedor con volumen, la conexión será:

```
WINDOWS (tu disco duro)                 CONTENEDOR (sistema virtual)
═══════════════════════                 ════════════════════════════

C:\apache-proyecto\htdocs\              /usr/local/apache2/htdocs/
         │                                         │
         │                                         │
         └─────────── MISMO CONTENIDO ─────────────┘
         
Carpeta en tu PC                        Carpeta que Apache lee
que puedes ver en el                    dentro del contenedor
Explorador de Windows                   
```

Todo lo que pongas en `C:\apache-proyecto\htdocs\` aparecerá automáticamente en `/usr/local/apache2/htdocs/` del contenedor.

### 7.9 Crear el archivo HTML

Ha llegado el momento de crear tu primer archivo HTML que Apache servirá. Este archivo debe estar dentro de la carpeta `C:\apache-proyecto\htdocs\` que creaste anteriormente. Te proporcionamos un HTML completo con estilos modernos para que veas un resultado visualmente atractivo. Puedes crearlo de dos formas: usando PowerShell (más rápido) o manualmente (si prefieres usar un editor visual).

**Opción 1: Usando PowerShell (crea el archivo con contenido)**

```powershell
# Este comando crea el archivo index.html con contenido HTML
# @" ... "@ es una "here-string" que permite escribir múltiples líneas
@"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Sitio con Docker</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
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
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 40px;
            max-width: 600px;
            text-align: center;
        }
        .status {
            background: #00d97e;
            color: #000;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: bold;
            margin-bottom: 20px;
            display: inline-block;
        }
        h1 {
            color: #00d9ff;
            margin-bottom: 20px;
            font-size: 2em;
        }
        p {
            line-height: 1.8;
            margin-bottom: 15px;
        }
        .path {
            background: rgba(0, 217, 255, 0.1);
            padding: 4px 12px;
            border-radius: 4px;
            font-family: 'Consolas', monospace;
            font-size: 0.9em;
        }
        .info-section {
            text-align: left;
            margin-top: 30px;
            padding: 20px;
            background: rgba(0, 0, 0, 0.2);
            border-radius: 8px;
        }
        .info-section h2 {
            color: #ff6b6b;
            font-size: 1.1em;
            margin-bottom: 15px;
        }
        ul {
            list-style: none;
        }
        li {
            padding: 8px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        li:last-child {
            border-bottom: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <span class="status">SERVIDOR OPERATIVO</span>
        <h1>Apache HTTP Server en Docker</h1>
        <p>Esta pagina se sirve desde un <strong>volumen montado</strong>.</p>
        <p>Archivo ubicado en: <span class="path">C:\apache-proyecto\htdocs\index.html</span></p>
        
        <div class="info-section">
            <h2>Configuracion del contenedor</h2>
            <ul>
                <li><strong>Imagen:</strong> httpd:2.4</li>
                <li><strong>Puerto host:</strong> 8080</li>
                <li><strong>Puerto contenedor:</strong> 80</li>
                <li><strong>Volumen:</strong> C:\apache-proyecto\htdocs → /usr/local/apache2/htdocs</li>
            </ul>
        </div>
        
        <div class="info-section">
            <h2>Prueba de actualizacion</h2>
            <p>Edita este archivo en Windows y recarga el navegador. Los cambios apareceran inmediatamente.</p>
        </div>
    </div>
</body>
</html>
"@ | Out-File -FilePath C:\apache-proyecto\htdocs\index.html -Encoding UTF8
```

**¿Qué hace este comando?**
- `@" ... "@` define un texto de múltiples líneas
- `| Out-File` toma ese texto y lo guarda en un archivo
- `-FilePath C:\apache-proyecto\htdocs\index.html` especifica dónde guardarlo
- `-Encoding UTF8` asegura que los caracteres especiales se guarden correctamente

**Opción 2: Crear el archivo manualmente**

1. Abre el Explorador de Windows (`Windows + E`)
2. Navega a `C:\apache-proyecto\htdocs`
3. Clic derecho → Nuevo → Documento de texto
4. Renómbralo a `index.html` (asegúrate de que no quede como `index.html.txt`)
5. Ábrelo con un editor de texto (Notepad, VS Code)
6. Pega el contenido HTML anterior
7. Guarda el archivo

### 7.10 Verificar que el archivo HTML existe

```powershell
# Ver el contenido de la carpeta htdocs
Get-ChildItem C:\apache-proyecto\htdocs
```

**Salida esperada:**
```
    Directory: C:\apache-proyecto\htdocs

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        15/01/2024     10:35           2500 index.html
```

```powershell
# Ver las primeras líneas del archivo para confirmar el contenido
Get-Content C:\apache-proyecto\htdocs\index.html -Head 5
```

**Salida esperada:**
```
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
```

### 7.11 Estructura final del proyecto

```
C:\
└── apache-proyecto\
    └── htdocs\
        └── index.html      ← Tu página web
```

### 7.12 Ejecutar el contenedor con el volumen montado

Si tienes un contenedor anterior corriendo, elimínalo primero:

```powershell
docker rm -f apache-basico 2>$null
```
(El `2>$null` oculta el error si el contenedor no existe)

Ahora ejecuta el nuevo contenedor:

```powershell
docker run -d --name apache-volumen -p 8080:80 -v C:\apache-proyecto\htdocs:/usr/local/apache2/htdocs httpd:2.4
```

### 7.13 Explicación del parámetro de volumen

El parámetro `-v` tiene el formato: `-v <ruta_host>:<ruta_contenedor>`

```
-v C:\apache-proyecto\htdocs:/usr/local/apache2/htdocs
   └──────────┬──────────────┘ └──────────┬──────────────┘
              │                           │
    Carpeta en TU PC             Carpeta DENTRO del contenedor
    (donde tienes tu HTML)       (donde Apache busca archivos)
```

**Visualización del montaje:**

```
WINDOWS (tu PC)                         CONTENEDOR DOCKER
===============                         =================

C:\apache-proyecto\htdocs\              /usr/local/apache2/htdocs/
       │                                         │
       │            MONTADO CON -v               │
       │◄───────────────────────────────────────►│
       │                                         │
       └── index.html ◄─────────────────────────►└── index.html
       
Cuando editas index.html                Apache ve los cambios
en Windows...                           instantáneamente
```

### 7.14 Verificar que funciona

**Verificar que el contenedor está corriendo:**

```powershell
docker ps
```

**Salida esperada:**
```
CONTAINER ID   IMAGE       COMMAND              CREATED          STATUS          PORTS                  NAMES
b2c3d4e5f6a7   httpd:2.4   "httpd-foreground"   5 seconds ago    Up 4 seconds    0.0.0.0:8080->80/tcp   apache-volumen
```

**Abrir en el navegador:**

1. Abre tu navegador
2. Ve a `http://localhost:8080`
3. Deberías ver tu página personalizada (no "It works!")

### 7.15 Probar la actualización en tiempo real

Esta es la gran ventaja de usar volúmenes: puedes editar archivos sin reiniciar nada.

**Paso 1:** Abre el archivo en un editor

```powershell
notepad C:\apache-proyecto\htdocs\index.html
```

O usa VS Code:
```powershell
code C:\apache-proyecto\htdocs\index.html
```

**Paso 2:** Busca la línea que dice:
```html
<span class="status">SERVIDOR OPERATIVO</span>
```

**Paso 3:** Cámbiala por:
```html
<span class="status">SERVIDOR MODIFICADO - FUNCIONA!</span>
```

**Paso 4:** Guarda el archivo (Ctrl + S)

**Paso 5:** Vuelve al navegador y recarga la página (F5)

El cambio debe aparecer **inmediatamente** sin necesidad de reiniciar el contenedor.

### 7.16 Verificar el montaje desde dentro del contenedor

```powershell
docker exec apache-volumen cat /usr/local/apache2/htdocs/index.html | Select-Object -First 10
```

Esto muestra las primeras líneas del archivo que Apache ve dentro del contenedor. Debería coincidir exactamente con tu archivo en Windows.

## **Paso 8: Configuración personalizada de Apache**

Hasta ahora has usado Apache con su configuración por defecto, que funciona perfectamente para pruebas básicas. Sin embargo, en proyectos reales necesitarás personalizar cómo se comporta Apache: definir el nombre del servidor, configurar cómo se registran los logs, añadir cabeceras de seguridad, activar o desactivar módulos específicos, y mucho más. La configuración de Apache se realiza mediante un archivo llamado `httpd.conf`, que contiene directivas que controlan cada aspecto del servidor. En esta sección aprenderás a crear tu propia configuración personalizada y a montarla en el contenedor. Este conocimiento te dará control total sobre el comportamiento de tu servidor web y es esencial para cualquier trabajo serio con Apache.

### 8.1 ¿Por qué personalizar la configuración?

Podrías preguntarte: "¿Por qué molestarme en configurar Apache si la configuración por defecto funciona?" La respuesta es que la configuración por defecto está diseñada para ser genérica, no óptima para tu caso específico. En entornos profesionales, casi siempre necesitarás ajustar la configuración para cumplir con requisitos de seguridad, rendimiento o funcionalidad.

La configuración por defecto de Apache funciona, pero en proyectos reales necesitas:
- Definir el nombre del servidor
- Configurar logs
- Añadir headers de seguridad
- Cargar módulos específicos
- Definir reglas de acceso

### 8.2 Crear nueva estructura de proyecto

Vamos a crear un proyecto más completo que incluya no solo archivos web, sino también un archivo de configuración personalizada. Esta vez crearemos una estructura más profesional con carpetas separadas para el contenido web y para la configuración. Sigue estos pasos detalladamente:

**Ubicación del proyecto:** `C:\apache-custom`

#### Paso 8.2.1: Abrir PowerShell

Primero, necesitas abrir una ventana de PowerShell:

1. Presiona `Windows + X` en tu teclado
2. En el menú que aparece, haz clic en **Windows PowerShell** o **Terminal**
3. Espera a que aparezca la ventana con el cursor parpadeante

#### Paso 8.2.2: Crear la carpeta principal del proyecto

Ahora vamos a crear la carpeta raíz de nuestro proyecto de configuración personalizada. Escribe el siguiente comando y presiona Enter:

```powershell
New-Item -ItemType Directory -Path C:\apache-custom -Force
```

**¿Qué hace este comando?**
- `New-Item`: Comando de PowerShell para crear nuevos elementos
- `-ItemType Directory`: Especifica que queremos crear una carpeta (no un archivo)
- `-Path C:\apache-custom`: La ruta completa donde se creará la carpeta
- `-Force`: Si la carpeta ya existe, no mostrará error

**Resultado esperado:**
```
    Directory: C:\

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        xx/xx/xxxx     xx:xx                apache-custom
```

#### Paso 8.2.3: Crear la carpeta para archivos web (htdocs)

Dentro de la carpeta principal, crearemos la subcarpeta donde irán nuestros archivos HTML, CSS, imágenes, etc.:

```powershell
New-Item -ItemType Directory -Path C:\apache-custom\htdocs -Force
```

**Resultado esperado:**
```
    Directory: C:\apache-custom

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        xx/xx/xxxx     xx:xx                htdocs
```

#### Paso 8.2.4: Crear la carpeta para configuración (conf)

También necesitamos una carpeta donde guardaremos el archivo de configuración de Apache:

```powershell
New-Item -ItemType Directory -Path C:\apache-custom\conf -Force
```

**Resultado esperado:**
```
    Directory: C:\apache-custom

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        xx/xx/xxxx     xx:xx                conf
```

#### Paso 8.2.5: Verificar la estructura creada

Es importante verificar que todo se creó correctamente. Ejecuta este comando para ver la estructura completa:

```powershell
Get-ChildItem C:\apache-custom
```

**Resultado esperado:**
```
    Directory: C:\apache-custom

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        xx/xx/xxxx     xx:xx                conf
d-----        xx/xx/xxxx     xx:xx                htdocs
```

¡Perfecto! Si ves ambas carpetas (`conf` y `htdocs`), has creado correctamente la estructura.

**Estructura resultante:**
```
C:\
└── apache-custom\
    ├── htdocs\           ← Aquí irán tus archivos web (HTML, CSS, JS)
    └── conf\             ← Aquí irá el archivo de configuración httpd.conf
```

### 8.3 Obtener la configuración original como referencia

Antes de crear nuestra configuración personalizada, es muy útil obtener una copia de la configuración original de Apache para usarla como referencia. Esto te permitirá ver todas las directivas disponibles y entender cómo está estructurado el archivo. Aunque no la modificaremos directamente, tenerla a mano es invaluable para aprender.

**Ejecuta los siguientes comandos uno por uno:**

```powershell
# Paso 1: Crear un contenedor temporal para extraer la configuración
docker run -d --name temp-apache httpd:2.4
```

```powershell
# Paso 2: Copiar el archivo de configuración del contenedor a tu PC
docker cp temp-apache:/usr/local/apache2/conf/httpd.conf C:\apache-custom\conf\httpd-original.conf
```

```powershell
# Paso 3: Eliminar el contenedor temporal (ya no lo necesitamos)
docker rm -f temp-apache
```

```powershell
# Paso 4 (opcional): Abrir el archivo para explorarlo
notepad C:\apache-custom\conf\httpd-original.conf
```

¡Ahora tienes el archivo original como referencia!

### 8.4 Crear configuración personalizada

Ahora crearemos nuestro propio archivo de configuración. Este archivo define cómo se comportará Apache: qué módulos cargar, dónde buscar los archivos, cómo manejar las conexiones, qué cabeceras de seguridad enviar, etc. Hemos incluido comentarios explicativos para cada sección para que puedas entender qué hace cada parte.

**Ejecuta este comando en PowerShell para crear el archivo de configuración:**

```powershell
@"
# ==============================================================================
# CONFIGURACION APACHE HTTP SERVER PERSONALIZADA
# ==============================================================================

# Directorio raiz de instalacion de Apache
ServerRoot "/usr/local/apache2"

# Puerto en el que Apache escucha conexiones
Listen 80

# ==============================================================================
# MODULOS
# Los modulos extienden la funcionalidad de Apache
# ==============================================================================

# MPM (Multi-Processing Module) - Como maneja conexiones concurrentes
LoadModule mpm_event_module modules/mod_mpm_event.so

# Modulos de autenticacion
LoadModule authn_core_module modules/mod_authn_core.so
LoadModule authz_host_module modules/mod_authz_host.so
LoadModule authz_core_module modules/mod_authz_core.so

# Modulos esenciales
LoadModule dir_module modules/mod_dir.so
LoadModule mime_module modules/mod_mime.so
LoadModule log_config_module modules/mod_log_config.so
LoadModule unixd_module modules/mod_unixd.so
LoadModule headers_module modules/mod_headers.so
LoadModule rewrite_module modules/mod_rewrite.so
LoadModule setenvif_module modules/mod_setenvif.so

# ==============================================================================
# CONFIGURACION DEL SERVIDOR
# ==============================================================================

# Usuario y grupo bajo el que corre Apache (por seguridad, no root)
<IfModule unixd_module>
    User www-data
    Group www-data
</IfModule>

# Nombre del servidor y puerto
ServerName localhost:80

# Email del administrador (aparece en paginas de error)
ServerAdmin admin@localhost

# Ocultar version de Apache en errores (seguridad)
ServerSignature Off
ServerTokens Prod

# ==============================================================================
# DIRECTORIO DE DOCUMENTOS (donde estan tus archivos web)
# ==============================================================================

# DocumentRoot es LA carpeta donde Apache busca archivos
DocumentRoot "/usr/local/apache2/htdocs"

# Configuracion de permisos para DocumentRoot
<Directory "/usr/local/apache2/htdocs">
    # Options:
    # - Indexes: muestra lista de archivos si no hay index.html (desactivar en produccion)
    # - FollowSymLinks: permite enlaces simbolicos
    Options Indexes FollowSymLinks
    
    # AllowOverride: permite usar archivos .htaccess
    AllowOverride All
    
    # Require: control de acceso (granted = permitir a todos)
    Require all granted
</Directory>

# Archivos que Apache busca cuando accedes a un directorio
<IfModule dir_module>
    DirectoryIndex index.html index.htm
</IfModule>

# Denegar acceso a archivos .htaccess y .htpasswd
<Files ".ht*">
    Require all denied
</Files>

# ==============================================================================
# LOGS
# ==============================================================================

# Nivel de log: debug, info, notice, warn, error, crit, alert, emerg
LogLevel warn

# Formato de logs
<IfModule log_config_module>
    # combined: incluye Referer y User-Agent
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    # common: formato basico
    LogFormat "%h %l %u %t \"%r\" %>s %b" common
    
    # En Docker, redirigimos logs a stdout/stderr para verlos con docker logs
    CustomLog /proc/self/fd/1 combined
</IfModule>

ErrorLog /proc/self/fd/2

# ==============================================================================
# TIPOS MIME
# ==============================================================================

<IfModule mime_module>
    TypesConfig conf/mime.types
    AddDefaultCharset UTF-8
</IfModule>

# ==============================================================================
# HEADERS DE SEGURIDAD
# ==============================================================================

<IfModule headers_module>
    # Prevenir que el navegador intente adivinar el tipo MIME
    Header always set X-Content-Type-Options "nosniff"
    
    # Prevenir clickjacking
    Header always set X-Frame-Options "SAMEORIGIN"
    
    # Activar filtro XSS del navegador
    Header always set X-XSS-Protection "1; mode=block"
</IfModule>

# ==============================================================================
# TIMEOUTS Y KEEPALIVE
# ==============================================================================

# Tiempo maximo para recibir una peticion completa
Timeout 60

# Mantener conexiones abiertas para multiples peticiones
KeepAlive On
MaxKeepAliveRequests 100
KeepAliveTimeout 5
"@ | Out-File -FilePath C:\apache-custom\conf\httpd.conf -Encoding ASCII
```

**Nota importante:** El archivo de configuración debe guardarse con encoding ASCII, no UTF8 con BOM.

### 8.5 Crear página HTML

Ahora necesitamos crear el contenido web que Apache servirá. Este HTML mostrará información sobre nuestra configuración personalizada, incluyendo las directivas que hemos definido y los headers de seguridad activos. Es una excelente forma de verificar que nuestra configuración está funcionando correctamente.

**Ejecuta este comando para crear el archivo HTML:**

```powershell
@"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apache Configuracion Custom</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #0f0f23;
            color: #ccc;
            margin: 0;
            padding: 40px;
            line-height: 1.6;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
        }
        h1 {
            color: #00ff41;
            border-bottom: 2px solid #00ff41;
            padding-bottom: 10px;
        }
        h2 {
            color: #ffcc00;
            margin-top: 30px;
        }
        .status {
            background: #00ff41;
            color: #000;
            padding: 10px 20px;
            border-radius: 6px;
            display: inline-block;
            font-weight: bold;
            margin-bottom: 20px;
        }
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
        th {
            background: #16213e;
            color: #00d9ff;
        }
        code {
            background: #1a1a2e;
            padding: 2px 8px;
            border-radius: 4px;
            color: #00ff41;
            font-family: Consolas, monospace;
        }
    </style>
</head>
<body>
    <div class="container">
        <span class="status">CONFIGURACION PERSONALIZADA ACTIVA</span>
        <h1>Apache HTTP Server</h1>
        <p>Este servidor usa un archivo <code>httpd.conf</code> personalizado.</p>
        
        <h2>Directivas configuradas</h2>
        <table>
            <tr><th>Directiva</th><th>Valor</th></tr>
            <tr><td>ServerName</td><td><code>localhost:80</code></td></tr>
            <tr><td>DocumentRoot</td><td><code>/usr/local/apache2/htdocs</code></td></tr>
            <tr><td>LogLevel</td><td><code>warn</code></td></tr>
            <tr><td>KeepAlive</td><td><code>On</code></td></tr>
            <tr><td>Timeout</td><td><code>60</code></td></tr>
        </table>
        
        <h2>Modulos cargados</h2>
        <p>mpm_event, dir, mime, log_config, headers, rewrite</p>
        
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

### 8.6 Verificar estructura creada

Antes de ejecutar el contenedor, verifiquemos que todos los archivos están en su lugar. Esta verificación evitará errores confusos más adelante.

**Ejecuta el siguiente comando:**

```powershell
Get-ChildItem C:\apache-custom -Recurse
```

**Salida esperada:**
```
    Directory: C:\apache-custom

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        15/01/2024     11:00                conf
d-----        15/01/2024     11:00                htdocs

    Directory: C:\apache-custom\conf

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        15/01/2024     11:00           3500 httpd.conf
-a----        15/01/2024     10:55          25000 httpd-original.conf

    Directory: C:\apache-custom\htdocs

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        15/01/2024     11:00           2200 index.html
```

### 8.7 Ejecutar con configuración personalizada

Ahora viene el momento más importante: ejecutar Apache con nuestra configuración personalizada. Usaremos dos volúmenes: uno para los archivos web y otro para el archivo de configuración. Observa que el volumen de configuración usa el sufijo `:ro` (read-only) para evitar que el contenedor modifique accidentalmente el archivo.

**Primero, elimina cualquier contenedor anterior que pueda causar conflictos:**

```powershell
docker rm -f apache-volumen 2>$null
```

Ejecuta el nuevo contenedor:

```powershell
docker run -d `
    --name apache-custom `
    -p 8080:80 `
    -v C:\apache-custom\htdocs:/usr/local/apache2/htdocs `
    -v C:\apache-custom\conf\httpd.conf:/usr/local/apache2/conf/httpd.conf:ro `
    httpd:2.4
```

**Nota sobre las comillas invertidas (`):** En PowerShell, se usa ` para continuar un comando en la siguiente línea.

**Explicación de los volúmenes:**

| Volumen | Propósito |
|---------|-----------|
| `-v C:\apache-custom\htdocs:/usr/local/apache2/htdocs` | Monta tus archivos web |
| `-v C:\apache-custom\conf\httpd.conf:/usr/local/apache2/conf/httpd.conf:ro` | Monta tu configuración (`:ro` = read-only) |

### 8.8 Verificar que la configuración funciona

Ahora debemos comprobar que Apache cargó correctamente nuestra configuración personalizada. Hay varias formas de verificarlo, y es buena práctica usar todas ellas para asegurar que todo está correcto.

**Verificar que la sintaxis de la configuración es correcta:**

```powershell
docker exec apache-custom httpd -t
```

**Salida esperada:**
```
Syntax OK
```

**Verificar headers de seguridad:**

```powershell
curl -I http://localhost:8080
```

O en PowerShell:

```powershell
Invoke-WebRequest -Uri http://localhost:8080 -Method Head | Select-Object -ExpandProperty Headers
```

**Salida esperada (parcial):**
```
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
```

Si ves estos headers, tu configuración personalizada está funcionando.

## **Paso 9: Múltiples sitios web**

¿Qué pasa cuando necesitas ejecutar más de un sitio web en tu computadora? Quizás tienes un proyecto de desarrollo, otro para pruebas, y otro que simula producción. O tal vez trabajas en varios proyectos diferentes para distintos clientes. Docker hace esto increíblemente fácil: puedes ejecutar múltiples contenedores Apache simultáneamente, cada uno con su propio contenido y accesible en un puerto diferente. En esta sección crearemos tres sitios web distintos funcionando al mismo tiempo, cada uno con su propio diseño y color para que sea fácil distinguirlos. Este ejercicio te preparará para escenarios del mundo real donde necesitas gestionar múltiples entornos o proyectos.

### 9.1 Escenario

Vamos a simular un escenario común en empresas de desarrollo de software: tener entornos separados para desarrollo, staging (pruebas) y producción. Cada entorno tendrá su propio contenedor Apache, su propio puerto, y un diseño visual distintivo para evitar confusiones.

Vamos a crear tres sitios web diferentes, cada uno en su propio contenedor y puerto.

| Sitio | Puerto | Color | Propósito simulado |
|-------|--------|-------|-------------------|
| sitio1 | 8081 | Azul | Desarrollo |
| sitio2 | 8082 | Verde | Staging |
| sitio3 | 8083 | Rojo | Producción |

### 9.2 Crear estructura

Primero, crearemos la estructura de carpetas para nuestros tres sitios. Cada sitio tendrá su propia carpeta donde colocaremos su archivo HTML personalizado. Sigue estos pasos exactamente como se describen.

**Ubicación del proyecto:** `C:\multi-sitios`

**Ejecuta los siguientes comandos para crear las carpetas:**

```powershell
# Crear carpeta base y subcarpetas para cada sitio
New-Item -ItemType Directory -Path C:\multi-sitios -Force
New-Item -ItemType Directory -Path C:\multi-sitios\sitio1 -Force
New-Item -ItemType Directory -Path C:\multi-sitios\sitio2 -Force
New-Item -ItemType Directory -Path C:\multi-sitios\sitio3 -Force
```

**Estructura:**
```
C:\
└── multi-sitios\
    ├── sitio1\
    ├── sitio2\
    └── sitio3\
```

### 9.3 Crear contenido de cada sitio

Ahora crearemos el contenido HTML para cada uno de nuestros tres sitios. Cada sitio tendrá un diseño distintivo con colores diferentes para que puedas identificar fácilmente en cuál de los tres entornos te encuentras. Esta práctica de usar indicadores visuales es muy común en el desarrollo profesional.

**Sitio 1 (Desarrollo - Color Azul):**

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
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            font-family: 'Segoe UI', sans-serif;
        }
        .card {
            background: white;
            padding: 60px 80px;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        h1 { color: #1e3c72; margin: 0 0 10px 0; font-size: 3em; }
        p { color: #666; margin: 0; font-size: 1.2em; }
        .port {
            background: #1e3c72;
            color: white;
            padding: 8px 24px;
            border-radius: 25px;
            display: inline-block;
            margin-top: 20px;
            font-weight: bold;
        }
        .env {
            color: #2a5298;
            font-size: 0.9em;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>SITIO 1</h1>
        <p>Entorno de Desarrollo</p>
        <div class="port">Puerto 8081</div>
        <p class="env">Contenedor: sitio1</p>
    </div>
</body>
</html>
"@ | Out-File -FilePath C:\multi-sitios\sitio1\index.html -Encoding UTF8
```

**Sitio 2 (Staging - Verde):**

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
            background: linear-gradient(135deg, #134e5e 0%, #71b280 100%);
            font-family: 'Segoe UI', sans-serif;
        }
        .card {
            background: white;
            padding: 60px 80px;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        h1 { color: #134e5e; margin: 0 0 10px 0; font-size: 3em; }
        p { color: #666; margin: 0; font-size: 1.2em; }
        .port {
            background: #134e5e;
            color: white;
            padding: 8px 24px;
            border-radius: 25px;
            display: inline-block;
            margin-top: 20px;
            font-weight: bold;
        }
        .env {
            color: #71b280;
            font-size: 0.9em;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>SITIO 2</h1>
        <p>Entorno de Staging</p>
        <div class="port">Puerto 8082</div>
        <p class="env">Contenedor: sitio2</p>
    </div>
</body>
</html>
"@ | Out-File -FilePath C:\multi-sitios\sitio2\index.html -Encoding UTF8
```

**Sitio 3 (Producción - Rojo):**

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
            background: linear-gradient(135deg, #cb2d3e 0%, #ef473a 100%);
            font-family: 'Segoe UI', sans-serif;
        }
        .card {
            background: white;
            padding: 60px 80px;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        h1 { color: #cb2d3e; margin: 0 0 10px 0; font-size: 3em; }
        p { color: #666; margin: 0; font-size: 1.2em; }
        .port {
            background: #cb2d3e;
            color: white;
            padding: 8px 24px;
            border-radius: 25px;
            display: inline-block;
            margin-top: 20px;
            font-weight: bold;
        }
        .env {
            color: #ef473a;
            font-size: 0.9em;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>SITIO 3</h1>
        <p>Entorno de Produccion</p>
        <div class="port">Puerto 8083</div>
        <p class="env">Contenedor: sitio3</p>
    </div>
</body>
</html>
"@ | Out-File -FilePath C:\multi-sitios\sitio3\index.html -Encoding UTF8
```

### 9.4 Verificar archivos creados

Antes de ejecutar los contenedores, verifiquemos que todos los archivos están en su lugar. Este paso te ayudará a detectar cualquier error antes de continuar.

```powershell
Get-ChildItem C:\multi-sitios -Recurse
```

### 9.5 Eliminar contenedores anteriores

Para evitar conflictos de puertos, primero eliminemos cualquier contenedor que hayamos creado anteriormente:

```powershell
docker rm -f apache-basico apache-volumen apache-custom 2>$null
```

### 9.6 Ejecutar los tres contenedores

Ahora ejecutaremos los tres contenedores Apache simultáneamente. Cada uno escuchará en un puerto diferente (8081, 8082, 8083) y mostrará el contenido de su respectiva carpeta. Observa cómo usamos el sufijo `:ro` (read-only) en los volúmenes para proteger nuestros archivos.

**Ejecuta estos comandos uno por uno:**

```powershell
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

### 9.7 Verificar que los tres contenedores están corriendo

Usemos `docker ps` para confirmar que nuestros tres contenedores están funcionando correctamente. Este comando mostrará solo los contenedores activos.

```powershell
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

**Salida esperada:**
```
NAMES    STATUS         PORTS
sitio3   Up 5 seconds   0.0.0.0:8083->80/tcp
sitio2   Up 8 seconds   0.0.0.0:8082->80/tcp
sitio1   Up 12 seconds  0.0.0.0:8081->80/tcp
```

### 9.8 Probar cada sitio

¡Ahora viene la parte divertida! Abre tu navegador y visita cada uno de los sitios para ver los diferentes diseños:

Abre en el navegador:
- http://localhost:8081 → Azul (Desarrollo)
- http://localhost:8082 → Verde (Staging)
- http://localhost:8083 → Rojo (Producción)

### 9.9 Ver uso de recursos

Con tres contenedores corriendo, es interesante ver cuántos recursos están consumiendo. Docker proporciona un comando similar al Administrador de Tareas de Windows para ver el uso de CPU y memoria de cada contenedor.

```powershell
docker stats --no-stream
```

**Salida:**
```
CONTAINER ID   NAME     CPU %     MEM USAGE / LIMIT     MEM %
a1b2c3d4e5f6   sitio1   0.00%     25.5MiB / 7.77GiB     0.32%
b2c3d4e5f6a7   sitio2   0.00%     24.8MiB / 7.77GiB     0.31%
c3d4e5f6a7b8   sitio3   0.00%     25.1MiB / 7.77GiB     0.31%
```

## **Paso 10: Construcción de imágenes con Dockerfile**

Hasta ahora hemos usado la imagen oficial de Apache y la hemos personalizado mediante volúmenes. Sin embargo, existe una forma más profesional y reproducible de crear configuraciones personalizadas: construir tu propia imagen Docker. Un **Dockerfile** es como una receta de cocina que le dice a Docker cómo construir una imagen paso a paso. La ventaja de tener tu propia imagen es que todo tu contenido y configuración quedan "empaquetados" dentro de ella. Puedes compartir esta imagen con compañeros de equipo, subirla a un registro Docker, o usarla en servidores de producción con la garantía de que funcionará exactamente igual en todas partes. Este paso te introduce al mundo de la creación de imágenes personalizadas, una habilidad fundamental para cualquier desarrollador que trabaje con Docker.

### 10.1 ¿Qué es un Dockerfile?

Un **Dockerfile** es un archivo de texto simple que contiene instrucciones ordenadas para construir una imagen Docker. Cada línea del archivo es una instrucción que Docker ejecuta secuencialmente: desde definir qué imagen base usar, hasta copiar archivos, instalar paquetes, y configurar cómo se ejecutará el contenedor. Aprender a escribir Dockerfiles es el puente entre "usar Docker" y "dominar Docker".

### 10.2 ¿Por qué crear tu propia imagen?

Podrías preguntarte cuándo deberías crear tu propia imagen en lugar de usar volúmenes. La respuesta depende del contexto. Para desarrollo local, los volúmenes son convenientes porque ves los cambios inmediatamente. Para distribución y producción, las imágenes personalizadas son superiores porque todo está empaquetado y no dependes de archivos externos.

| Usar imagen base + volúmenes | Crear imagen propia |
|------------------------------|---------------------|
| Bueno para desarrollo | Bueno para distribución |
| Archivos fuera del contenedor | Todo incluido en la imagen |
| Requiere montar volúmenes | Solo `docker run imagen` |
| Cambios en tiempo real | Cambios requieren rebuild |

### 10.3 Crear estructura del proyecto

Vamos a crear un proyecto completo que incluirá un Dockerfile, archivos de configuración, y contenido web. Esta estructura es más organizada y profesional que las anteriores.

**Ubicación del proyecto:** `C:\mi-imagen-apache`

**Ejecuta estos comandos para crear la estructura:**

```powershell
# Crear carpeta del proyecto
New-Item -ItemType Directory -Path C:\mi-imagen-apache -Force
Set-Location C:\mi-imagen-apache

# Crear subcarpetas
New-Item -ItemType Directory -Path .\src -Force
New-Item -ItemType Directory -Path .\conf -Force
```

**Estructura:**
```
C:\mi-imagen-apache\
├── Dockerfile        ← Instrucciones de construcción
├── conf\
│   └── httpd.conf    ← Configuración de Apache
└── src\
    └── index.html    ← Tu sitio web
```

### 10.4 Crear el Dockerfile

Este es el corazón de nuestra imagen personalizada. El Dockerfile contiene todas las instrucciones para construir la imagen. Cada instrucción tiene un propósito específico que explicamos en los comentarios. Léelo con atención.

**Ejecuta este comando para crear el Dockerfile:**

```powershell
@"
# ==============================================================================
# DOCKERFILE - Imagen personalizada de Apache
# ==============================================================================

# FROM: Define la imagen base sobre la que construimos
# httpd:2.4-alpine usa Alpine Linux (muy ligero, ~5MB)
FROM httpd:2.4-alpine

# LABEL: Metadatos de la imagen (opcional pero recomendado)
LABEL maintainer="tu-email@ejemplo.com"
LABEL version="1.0"
LABEL description="Imagen Apache personalizada"

# ENV: Define variables de entorno disponibles en el contenedor
ENV APACHE_LOG_DIR=/usr/local/apache2/logs

# RUN: Ejecuta comandos durante la construccion de la imagen
# Instalamos curl para poder hacer healthchecks
RUN apk add --no-cache curl

# COPY: Copia archivos desde tu PC a la imagen
# Sintaxis: COPY <origen_en_tu_pc> <destino_en_imagen>
COPY conf/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY src/ /usr/local/apache2/htdocs/

# RUN: Establecer permisos correctos
RUN chown -R www-data:www-data /usr/local/apache2/htdocs && \
    chmod -R 755 /usr/local/apache2/htdocs

# EXPOSE: Documenta que el contenedor escuchara en este puerto
# (No abre el puerto, solo lo documenta)
EXPOSE 80

# HEALTHCHECK: Define como verificar si el contenedor esta sano
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# CMD: Comando por defecto cuando se inicia el contenedor
# (Heredado de la imagen base, pero lo dejamos explicito)
CMD ["httpd-foreground"]
"@ | Out-File -FilePath C:\mi-imagen-apache\Dockerfile -Encoding ASCII
```

### 10.5 Crear configuración de Apache

Ahora crearemos un archivo de configuración simplificado para nuestra imagen. Esta configuración incluye lo esencial sin ser excesivamente compleja.

**Ejecuta este comando:**

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
"@ | Out-File -FilePath C:\mi-imagen-apache\conf\httpd.conf -Encoding ASCII
```

### 10.6 Crear contenido web

Finalmente, crearemos una página HTML moderna que mostrará información sobre nuestra imagen personalizada.

**Ejecuta este comando:**

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
            border-radius: 20px;
            padding: 50px;
            max-width: 600px;
            text-align: center;
        }
        .logo { font-size: 5em; margin-bottom: 20px; }
        h1 {
            font-size: 2.2em;
            margin-bottom: 10px;
            background: linear-gradient(90deg, #00d4ff, #00ff88);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .subtitle { color: #888; margin-bottom: 40px; }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }
        .info-card {
            background: rgba(0,212,255,0.05);
            border: 1px solid rgba(0,212,255,0.2);
            border-radius: 10px;
            padding: 20px;
            text-align: left;
        }
        .info-card h3 {
            color: #00d4ff;
            font-size: 0.8em;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }
        .info-card p {
            color: #ccc;
            font-family: Consolas, monospace;
            font-size: 0.95em;
        }
        .badge {
            display: inline-block;
            background: linear-gradient(90deg, #00d4ff, #00ff88);
            color: #000;
            padding: 10px 30px;
            border-radius: 25px;
            font-weight: bold;
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">🐳</div>
        <h1>Imagen Docker Personalizada</h1>
        <p class="subtitle">Construida con Dockerfile</p>
        
        <div class="info-grid">
            <div class="info-card">
                <h3>Base</h3>
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
                <p>Activo</p>
            </div>
        </div>
        
        <span class="badge">BUILD EXITOSO</span>
    </div>
</body>
</html>
"@ | Out-File -FilePath C:\mi-imagen-apache\src\index.html -Encoding UTF8
```

### 10.7 Verificar estructura

Antes de construir la imagen, verifiquemos que todos los archivos están en su lugar correcto:

```powershell
Get-ChildItem C:\mi-imagen-apache -Recurse
```

**Salida esperada:**
```
    Directory: C:\mi-imagen-apache

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        15/01/2024     12:00                conf
d-----        15/01/2024     12:00                src
-a----        15/01/2024     12:00           1200 Dockerfile

    Directory: C:\mi-imagen-apache\conf

-a----        15/01/2024     12:00           1100 httpd.conf

    Directory: C:\mi-imagen-apache\src

-a----        15/01/2024     12:00           2800 index.html
```

### 10.8 Construir la imagen

Ahora viene el momento más importante: construir nuestra imagen personalizada a partir del Dockerfile. Docker leerá el archivo, ejecutará cada instrucción en orden, y creará una nueva imagen.

**Ejecuta estos comandos:**

```powershell
# Navegar al directorio del proyecto
Set-Location C:\mi-imagen-apache

# Construir la imagen
docker build -t mi-apache:1.0 .
```

**Explicación:**
- `docker build` → Comando para construir imagen
- `-t mi-apache:1.0` → Tag (nombre:versión) de la imagen
- `.` → Ubicación del Dockerfile (directorio actual)

**Salida esperada:**
```
[+] Building 15.2s (11/11) FINISHED
 => [internal] load build definition from Dockerfile
 => [internal] load .dockerignore
 => [internal] load metadata for docker.io/library/httpd:2.4-alpine
 => [1/6] FROM docker.io/library/httpd:2.4-alpine
 => [2/6] RUN apk add --no-cache curl
 => [3/6] COPY conf/httpd.conf /usr/local/apache2/conf/httpd.conf
 => [4/6] COPY src/ /usr/local/apache2/htdocs/
 => [5/6] RUN chown -R www-data:www-data /usr/local/apache2/htdocs
 => exporting to image
 => => naming to docker.io/library/mi-apache:1.0
```

### 10.9 Verificar la imagen creada

Confirmemos que nuestra imagen se creó correctamente:

```powershell
docker images mi-apache
```

**Salida:**
```
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
mi-apache    1.0       abc123def456   30 seconds ago   60MB
```

### 10.10 Ejecutar la imagen personalizada

Ahora podemos crear un contenedor a partir de nuestra imagen. Nota que NO necesitamos volumen porque los archivos ya están DENTRO de la imagen.

**Ejecuta estos comandos:**

```powershell
# Eliminar contenedores previos
docker rm -f sitio1 sitio2 sitio3 2>$null

# Ejecutar
docker run -d --name mi-apache-container -p 8080:80 mi-apache:1.0
```

**Nota:** No necesitamos `-v` porque los archivos están DENTRO de la imagen.

### 10.11 Verificar

Comprobemos que todo funciona correctamente:

```powershell
# Ver que está corriendo
docker ps

# Verificar healthcheck (esperar 30 segundos)
Start-Sleep -Seconds 35
docker inspect mi-apache-container --format '{{.State.Health.Status}}'
```

**Salida esperada:**
```
healthy
```

Abre http://localhost:8080 para ver el resultado.

## **Paso 11: Docker Compose**

Hasta ahora has ejecutado contenedores individualmente con comandos `docker run`. Esto funciona bien para uno o dos contenedores, pero imagina que tienes una aplicación con 5, 10 o más servicios: ¿vas a escribir y recordar todos esos comandos largos cada vez? Aquí es donde entra **Docker Compose**. Compose te permite definir todos tus servicios en un único archivo YAML y luego levantarlos todos con un solo comando. Es como tener una orquesta donde Docker Compose es el director: coordina múltiples contenedores, sus conexiones de red, volúmenes, y configuraciones. Esta herramienta es fundamental para desarrollo local de aplicaciones modernas y es el paso natural después de dominar contenedores individuales.

### 11.1 ¿Qué es Docker Compose?

Docker Compose es una herramienta que simplifica la gestión de aplicaciones multi-contenedor. En lugar de ejecutar múltiples comandos `docker run` con todas sus opciones, defines tu infraestructura completa en un archivo llamado `docker-compose.yml` y usas comandos simples para controlarlo todo.

### 11.2 Crear proyecto

Vamos a crear un proyecto con tres servicios interconectados: una web principal, una API, y una sección de documentación. Cada servicio tendrá su propio contenedor Apache.

**Ubicación del proyecto:** `C:\compose-proyecto`

**Ejecuta estos comandos:**

```powershell
New-Item -ItemType Directory -Path C:\compose-proyecto -Force
Set-Location C:\compose-proyecto
New-Item -ItemType Directory -Path .\web-principal -Force
New-Item -ItemType Directory -Path .\web-api -Force
New-Item -ItemType Directory -Path .\web-docs -Force
```

### 11.3 Crear docker-compose.yml

Este archivo es el núcleo de Docker Compose. Define todos los servicios, sus imágenes, puertos, volúmenes, y relaciones. La sintaxis es YAML, que es muy legible pero sensible a la indentación (usa espacios, no tabuladores).

**Ejecuta este comando para crear el archivo:**

```powershell
@"
version: '3.8'

services:
  web:
    image: httpd:2.4
    container_name: compose-web
    ports:
      - "8080:80"
    volumes:
      - ./web-principal:/usr/local/apache2/htdocs:ro
    restart: unless-stopped

  api:
    image: httpd:2.4
    container_name: compose-api
    ports:
      - "8081:80"
    volumes:
      - ./web-api:/usr/local/apache2/htdocs:ro
    restart: unless-stopped
    depends_on:
      - web

  docs:
    image: httpd:2.4
    container_name: compose-docs
    ports:
      - "8082:80"
    volumes:
      - ./web-docs:/usr/local/apache2/htdocs:ro
    restart: unless-stopped
    depends_on:
      - web
"@ | Out-File -FilePath C:\compose-proyecto\docker-compose.yml -Encoding ASCII
```

### 11.4 Crear contenido

Ahora crearemos el contenido HTML para cada uno de los tres servicios. Cada página tendrá enlaces a los otros servicios para que puedas navegar entre ellos.

**Web Principal (puerto 8080):**
```powershell
@"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Portal Principal</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #1a1a2e; color: #eee; margin: 0; padding: 40px; }
        h1 { color: #e94560; }
        .services { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-top: 30px; }
        .service { background: #16213e; padding: 25px; border-radius: 10px; text-align: center; }
        .service h3 { color: #00d9ff; }
        a { color: #e94560; text-decoration: none; }
    </style>
</head>
<body>
    <h1>Docker Compose - Portal Principal</h1>
    <p>Tres servicios orquestados con Docker Compose</p>
    <div class="services">
        <div class="service">
            <h3>Web Principal</h3>
            <p>Puerto 8080</p>
            <a href="http://localhost:8080">Acceder</a>
        </div>
        <div class="service">
            <h3>API</h3>
            <p>Puerto 8081</p>
            <a href="http://localhost:8081">Acceder</a>
        </div>
        <div class="service">
            <h3>Docs</h3>
            <p>Puerto 8082</p>
            <a href="http://localhost:8082">Acceder</a>
        </div>
    </div>
</body>
</html>
"@ | Out-File -FilePath C:\compose-proyecto\web-principal\index.html -Encoding UTF8
```

**API:**
```powershell
@"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>API Service</title>
    <style>
        body { font-family: monospace; background: #0d1117; color: #c9d1d9; padding: 40px; }
        pre { background: #161b22; padding: 20px; border-radius: 6px; }
    </style>
</head>
<body>
    <h1>API Service - Puerto 8081</h1>
    <pre>
{
    "status": "success",
    "service": "api",
    "port": 8081
}
    </pre>
</body>
</html>
"@ | Out-File -FilePath C:\compose-proyecto\web-api\index.html -Encoding UTF8
```

**Docs:**
```powershell
@"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Documentacion</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; max-width: 800px; margin: 0 auto; padding: 40px; }
        h1 { border-bottom: 3px solid #0066cc; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background: #0066cc; color: white; }
    </style>
</head>
<body>
    <h1>Documentacion - Puerto 8082</h1>
    <table>
        <tr><th>Servicio</th><th>Puerto</th></tr>
        <tr><td>web</td><td>8080</td></tr>
        <tr><td>api</td><td>8081</td></tr>
        <tr><td>docs</td><td>8082</td></tr>
    </table>
</body>
</html>
"@ | Out-File -FilePath C:\compose-proyecto\web-docs\index.html -Encoding UTF8
```

### 11.5 Comandos de Docker Compose

Ahora usaremos Docker Compose para gestionar nuestros servicios. Estos comandos son mucho más simples que ejecutar múltiples `docker run`.

**Ejecuta estos comandos en orden:**

```powershell
# Navegar al proyecto
Set-Location C:\compose-proyecto

# Eliminar contenedores anteriores
docker rm -f mi-apache-container 2>$null

# Iniciar todos los servicios
docker compose up -d

# Ver estado
docker compose ps

# Ver logs
docker compose logs

# Detener todo
docker compose down
```

### 11.6 Verificar

Confirmemos que todos los servicios están corriendo:

```powershell
docker compose ps
```

**Salida:**
```
NAME           IMAGE       SERVICE   STATUS          PORTS
compose-api    httpd:2.4   api       Up 10 seconds   0.0.0.0:8081->80/tcp
compose-docs   httpd:2.4   docs      Up 10 seconds   0.0.0.0:8082->80/tcp
compose-web    httpd:2.4   web       Up 10 seconds   0.0.0.0:8080->80/tcp
```

## **Paso 12: Referencia de comandos**

Esta sección sirve como guía de referencia rápida para los comandos más importantes que has aprendido a lo largo del tutorial. Guarda esta página en tus favoritos o imprímela para tenerla a mano mientras trabajas con Docker. Con el tiempo, estos comandos se volverán automáticos, pero al principio es normal necesitar consultarlos frecuentemente.

### Comandos esenciales de Docker

Aquí tienes una tabla con los comandos que usarás más frecuentemente:

| Comando | Descripción |
|---------|-------------|
| `docker ps` | Lista contenedores activos |
| `docker ps -a` | Lista todos los contenedores |
| `docker images` | Lista imágenes |
| `docker run -d --name X -p Y:Z imagen` | Ejecuta contenedor |
| `docker stop X` | Detiene contenedor |
| `docker start X` | Inicia contenedor |
| `docker rm X` | Elimina contenedor |
| `docker logs X` | Ve logs |
| `docker exec -it X bash` | Entra al contenedor |
| `docker build -t nombre .` | Construye imagen |
| `docker compose up -d` | Inicia servicios Compose |
| `docker compose down` | Detiene servicios Compose |

### Limpieza del sistema

Con el tiempo, Docker acumula imágenes, contenedores detenidos, y otros recursos que ocupan espacio en disco. Estos comandos te ayudan a limpiar tu sistema:

```powershell
# Eliminar todos los contenedores
docker rm -f $(docker ps -aq)

# Eliminar imágenes no usadas
docker image prune -a

# Limpieza completa
docker system prune -a
```

## Ejercicios prácticos

¡Felicidades por completar el tutorial! Pero el aprendizaje no termina aquí. La mejor forma de consolidar tus conocimientos es poniendo en práctica lo aprendido. Los siguientes ejercicios están diseñados para desafiarte y ayudarte a explorar Docker por tu cuenta. Intenta resolverlos sin mirar las secciones anteriores del tutorial; usa los comandos de ayuda (`docker --help`, `docker run --help`, etc.) para descubrir opciones que quizás no cubrimos. Si te quedas atascado, vuelve a revisar la sección correspondiente del tutorial.

### Ejercicio 1: Servidor en puerto personalizado

**Objetivo:** Ejecuta un contenedor Apache en el puerto 9000 con una página HTML personalizada que incluya tu nombre y la fecha actual.

**Pistas:**
- Usa el parámetro `-p` para mapear el puerto 9000
- Crea una carpeta con un archivo `index.html` y móntala como volumen

### Ejercicio 2: Imagen Docker multi-página

**Objetivo:** Crea un Dockerfile que produzca una imagen con 3 páginas HTML diferentes (home, about, contact) y un archivo CSS compartido que les dé estilo.

**Pistas:**
- Crea una estructura de carpetas con los 4 archivos
- En el Dockerfile, usa `COPY` para copiar toda la carpeta al contenedor
- Accede a las páginas como `localhost:8080/about.html`, etc.

### Ejercicio 3: Docker Compose con múltiples servicios

**Objetivo:** Crea un archivo `docker-compose.yml` con 4 servicios Apache en los puertos 9001, 9002, 9003 y 9004, cada uno con un color de fondo diferente.

**Pistas:**
- Define 4 servicios en el archivo YAML
- Cada servicio debe tener su propia carpeta de contenido
- Usa `depends_on` para establecer el orden de inicio

**Desafío extra:** Añade un servicio adicional que use una imagen de Nginx en lugar de Apache.

## **Recursos adicionales**

Para profundizar en los temas cubiertos en este tutorial, te recomendamos los siguientes recursos oficiales:

- Docker: https://docs.docker.com
- Apache: https://httpd.apache.org/docs/2.4/
- Docker Hub httpd: https://hub.docker.com/_/httpd
