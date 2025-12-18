# Tutorial: Nginx con Docker en Windows

En este tutorial aprenderás a desplegar, configurar y administrar Nginx mediante contenedores Docker en Windows. Se cubren los fundamentos de ambas tecnologías de forma progresiva, desde la ejecución básica hasta la creación de imágenes personalizadas y orquestación con Docker Compose. Al finalizar, serás capaz de servir sitios web estáticos, configurar virtual hosts y gestionar múltiples servicios.

## **Paso 1: Verificación del entorno Docker**

Antes de comenzar a trabajar con contenedores y servidores web, es absolutamente fundamental confirmar que Docker está correctamente instalado y funcionando en tu sistema Windows. Docker Desktop es la aplicación oficial que permite ejecutar contenedores Linux en sistemas Windows mediante una sofisticada capa de virtualización llamada WSL2 (Windows Subsystem for Linux 2). Esta verificación inicial es un paso crítico que no debes omitir, ya que nos asegura que todos los componentes del sistema Docker están correctamente configurados, las conexiones de red funcionan adecuadamente, y el demonio de Docker puede crear y gestionar contenedores sin problemas. Dedicar unos minutos a esta comprobación te ahorrará horas de frustración resolviendo errores más adelante durante el desarrollo del tutorial.

### 1.1 Abrir PowerShell

PowerShell es la terminal moderna y potente de Windows que utilizaremos para ejecutar todos los comandos Docker a lo largo de este tutorial. A diferencia del antiguo CMD (Símbolo del sistema), PowerShell ofrece características avanzadas como autocompletado, historial de comandos mejorado, y soporte para scripts complejos. Viene preinstalada en Windows 10 y Windows 11, por lo que no necesitas instalar nada adicional para empezar a usarla.

1. Presiona `Windows + X`
2. Selecciona **Windows PowerShell** o **Terminal**
3. Se abrirá una ventana de línea de comandos

Por defecto, PowerShell se abre en tu directorio de usuario:
```
PS C:\Users\TuNombre>
```

### 1.2 Comprobar la instalación de Docker

Este comando de verificación es el primer paso para confirmar que Docker está correctamente instalado en tu sistema operativo. Cuando Docker responde mostrando su número de versión, significa que el programa cliente de Docker está disponible en el PATH del sistema y listo para comunicarse con el demonio Docker. Si recibes un error, significa que Docker no está instalado o no está configurado correctamente en las variables de entorno.

Ejecuta el siguiente comando (escríbelo y presiona Enter):

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

El demonio (daemon) de Docker es el servicio central que se ejecuta constantemente en segundo plano y es responsable de gestionar absolutamente todo lo relacionado con contenedores: crearlos, iniciarlos, detenerlos, eliminarlos, gestionar redes virtuales y almacenamiento. Sin este demonio ejecutándose activamente, aunque tengas Docker instalado, ningún comando funcionará porque no hay ningún proceso escuchando y ejecutando tus instrucciones. Este paso verifica que el demonio está activo.

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

Este comando representa la prueba definitiva y completa de que tu entorno Docker funciona correctamente de principio a fin. No solo verifica que Docker está instalado, sino que también confirma que puede conectarse a Internet para descargar imágenes desde Docker Hub, que puede crear contenedores a partir de esas imágenes, y que puede ejecutarlos correctamente mostrando su salida en la terminal. Si este comando funciona, puedes estar seguro de que todo está listo.

```powershell
docker run hello-world
```

**¿Qué hace este comando?**  
1. Busca la imagen `hello-world` en tu máquina local
2. Al no encontrarla, la descarga desde Docker Hub
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

Antes de adentrarnos en la configuración de Nginx, es absolutamente fundamental que comprendas cómo funciona Docker internamente, ya que este conocimiento te permitirá resolver problemas, optimizar configuraciones y entender por qué hacemos cada cosa de una manera específica. Docker utiliza una tecnología llamada contenedorización, que es una forma de virtualización ligera que permite ejecutar aplicaciones de manera completamente aislada del sistema operativo host. A diferencia de las máquinas virtuales tradicionales que requieren un sistema operativo completo para cada instancia, los contenedores Docker comparten el kernel del sistema operativo anfitrión, lo que los hace extraordinariamente más eficientes en términos de uso de memoria, espacio en disco y velocidad de inicio. Un contenedor puede arrancar en segundos, mientras que una máquina virtual puede tardar minutos.

### 2.1 Arquitectura de Docker

Docker utiliza una arquitectura cliente-servidor que es importante comprender para entender cómo fluyen los comandos desde tu terminal hasta la ejecución real de los contenedores. El cliente es el programa de línea de comandos que tú utilizas cuando escribes comandos como `docker run` o `docker ps`. Este cliente no ejecuta nada directamente, sino que envía tus instrucciones al demonio Docker (servidor), que es el verdadero motor que crea, ejecuta y gestiona todos los contenedores en tu sistema.

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

Los siguientes cuatro conceptos constituyen los pilares básicos de todo el ecosistema Docker y dominarlos es esencial para trabajar eficientemente con contenedores. Cada concepto se relaciona con los demás formando un sistema coherente: las imágenes son plantillas para crear contenedores, los contenedores son instancias en ejecución, los volúmenes permiten persistir datos, y los puertos permiten la comunicación con el exterior. Comprenderlos profundamente te permitirá trabajar con cualquier aplicación contenerizada.

#### Imagen (Image)
Una **imagen** es una plantilla de solo lectura. Contiene:
- Un sistema operativo base (ej: Debian, Alpine Linux)
- Software instalado (ej: Nginx)
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

La siguiente tabla resume los comandos Docker que utilizarás con mayor frecuencia durante tu trabajo diario con contenedores. Es recomendable que memorices estos comandos porque los usarás constantemente, tanto en desarrollo como en producción. Cada comando tiene un propósito específico y entender cuándo usar cada uno te hará más eficiente en la gestión de tus aplicaciones contenerizadas.

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

## **Paso 3: Nginx - Conceptos**

Nginx (pronunciado "engine-x") es uno de los servidores web más populares y ampliamente utilizados del mundo, sirviendo millones de sitios web en Internet. Fue creado originalmente por el ingeniero ruso Igor Sysoev en el año 2004 con el objetivo específico de resolver el famoso problema C10k, que consistía en manejar eficientemente 10,000 conexiones simultáneas en un solo servidor. A diferencia de servidores tradicionales como Apache que utilizan un modelo basado en procesos o hilos, Nginx implementa una arquitectura revolucionaria basada en eventos asíncronos que le permite manejar enormes cantidades de conexiones concurrentes con un consumo mínimo de memoria RAM. Además de funcionar como servidor web para archivos estáticos, Nginx puede actuar como proxy inverso, balanceador de carga, servidor de caché y terminador SSL/TLS.

### 3.1 ¿Qué es Nginx?

Nginx es fundamentalmente un servidor web de alto rendimiento cuya función principal consiste en escuchar peticiones HTTP que llegan desde los navegadores de los usuarios, procesar esas peticiones determinando qué recurso se está solicitando, y responder enviando el contenido apropiado de vuelta al navegador. Puede servir archivos estáticos directamente desde el disco o redirigir peticiones a aplicaciones backend como Node.js, Python o PHP.

```
┌──────────────┐         ┌──────────────────┐         ┌──────────────┐
│  Navegador   │         │      Nginx       │         │  Archivos    │
│  (Chrome,    │──HTTP──►│                  │────────►│  HTML, CSS,  │
│   Firefox)   │◄────────│                  │◄────────│  JS, imgs    │
│              │  HTML   │  Puerto 80       │         │              │
└──────────────┘         └──────────────────┘         └──────────────┘
```

1. Tu navegador envía una petición HTTP (ej: "quiero la página index.html")
2. Nginx recibe la petición
3. Nginx busca el archivo en el sistema de archivos
4. Nginx devuelve el archivo al navegador
5. El navegador renderiza la página

### 3.2 ¿Por qué usar Nginx con Docker?

La combinación de Docker con Nginx simplifica enormemente el proceso de despliegue y elimina los típicos problemas de compatibilidad entre sistemas operativos. No necesitas preocuparte por instalar dependencias, configurar permisos especiales, ni resolver conflictos con otros servicios que puedan estar usando el mismo puerto. Docker encapsula todo en un contenedor aislado y reproducible que funciona igual en cualquier máquina.

| Sin Docker | Con Docker |
|------------|------------|
| Instalar Nginx en Windows es complejo | Un solo comando descarga y ejecuta Nginx |
| Puede entrar en conflicto con otros programas | Cada contenedor está aislado |
| Difícil de desinstalar completamente | `docker rm` y desaparece |
| Configuración varía según SO | Mismo comportamiento en cualquier máquina |

### 3.3 Nginx vs Apache

Nginx y Apache son los dos servidores web más populares del mundo, y ambos son herramientas excelentes con años de desarrollo y comunidades activas. La elección entre uno u otro depende del caso de uso específico, los requisitos de rendimiento, y las necesidades particulares de tu proyecto. Apache es más flexible con módulos dinámicos mientras que Nginx destaca en rendimiento con archivos estáticos.

| Característica | Nginx | Apache |
|----------------|-------|--------|
| Arquitectura | Basada en eventos | Basada en procesos/hilos |
| Consumo de memoria | Bajo | Mayor |
| Archivos estáticos | Excelente rendimiento | Buen rendimiento |
| Configuración | Archivos `.conf` | Archivos `.conf` + `.htaccess` |
| Módulos | Se compilan con el servidor | Se cargan dinámicamente |

### 3.4 Estructura de directorios de Nginx (dentro del contenedor)

Cuando ejecutes Nginx dentro de un contenedor Docker, el contenedor tendrá internamente una estructura de directorios específica que es importante conocer. Entender esta estructura te permitirá saber exactamente dónde colocar tus archivos web, dónde encontrar y modificar la configuración del servidor, y dónde consultar los logs cuando necesites diagnosticar problemas o analizar el tráfico de tu sitio.

```
/etc/nginx/
├── nginx.conf              # ARCHIVO DE CONFIGURACIÓN PRINCIPAL
├── conf.d/
│   └── default.conf        # Configuración del servidor por defecto
├── mime.types              # Tipos de archivo
└── modules/                # Módulos de Nginx

/usr/share/nginx/html/      # ← AQUÍ VAN TUS ARCHIVOS WEB
├── index.html              # Página por defecto
└── 50x.html                # Página de error

/var/log/nginx/             # Logs
├── access.log              # Registro de accesos
└── error.log               # Registro de errores
```

**Lo más importante:**
- `/usr/share/nginx/html/` → Es donde Nginx busca los archivos web
- `/etc/nginx/nginx.conf` → Es el archivo de configuración principal
- `/etc/nginx/conf.d/` → Configuraciones adicionales de sitios

## **Paso 4: Descargar la imagen de Nginx**

Antes de poder ejecutar cualquier contenedor Nginx, necesitamos descargar su imagen desde Docker Hub, que es el registro público de imágenes de contenedores más grande y utilizado del mundo. En Docker Hub encontrarás imágenes oficiales que son creadas y mantenidas directamente por las organizaciones que desarrollan cada software, lo que garantiza que están optimizadas, son seguras, y reciben actualizaciones constantes cuando se descubren vulnerabilidades de seguridad. La imagen oficial de Nginx en Docker Hub ha sido descargada miles de millones de veces y es la base sobre la que construiremos nuestros contenedores. Descargar la imagen es un proceso que solo necesitas hacer una vez, ya que queda almacenada localmente en tu máquina.

### 4.1 ¿Qué vamos a hacer?

En este subpaso vamos a descargar la imagen oficial de Nginx desde el repositorio Docker Hub a tu máquina local. Esta imagen es un paquete completo que contiene el sistema operativo base Debian, el servidor Nginx ya instalado y configurado, y todos los archivos necesarios para que funcione correctamente sin ninguna configuración adicional de tu parte.

### 4.2 Ejecutar el comando de descarga

El comando `docker pull` es el encargado de conectarse a Docker Hub a través de Internet, buscar la imagen especificada, y descargar todas sus capas a tu sistema local. Cada imagen está compuesta por múltiples capas que se descargan en paralelo para optimizar el tiempo de descarga total. Las capas se reutilizan entre imágenes similares.

Abre PowerShell y ejecuta:

```powershell
docker pull nginx:1.25
```

**Desglose del comando:**

| Parte | Significado |
|-------|-------------|
| `docker pull` | Comando para descargar una imagen |
| `nginx` | Nombre de la imagen oficial de Nginx |
| `:1.25` | Tag/versión de la imagen (versión 1.25 de Nginx) |

**¿Por qué especificar la versión?**  
Si no especificas versión, Docker descarga `latest` (la última). Esto puede causar problemas porque `latest` cambia con el tiempo. Especificar `1.25` garantiza reproducibilidad.

**Salida esperada:**
```
1.25: Pulling from library/nginx
a2abf6c4d29d: Pull complete
a9edb18cadd1: Pull complete
589b7251471a: Pull complete
186b1aaa4aa6: Pull complete
b4df32aa5a72: Pull complete
a0bcbecc962e: Pull complete
Digest: sha256:0d17b565c37bcbd895e9d...
Status: Downloaded newer image for nginx:1.25
docker.io/library/nginx:1.25
```

Cada línea `Pull complete` es una **capa** de la imagen que se descarga.

### 4.3 Verificar que la imagen se descargó

Una vez completada la descarga, es importante verificar que la imagen está correctamente almacenada en tu sistema local. El comando `docker images` te muestra un listado completo de todas las imágenes disponibles, incluyendo su nombre, versión (tag), identificador único, fecha de creación y tamaño en disco. Deberías ver la imagen nginx:1.25 en la lista.

```powershell
docker images
```

**Salida esperada:**
```
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
nginx         1.25      a6bd71f48f68   2 weeks ago    187MB
hello-world   latest    d2c94e258dcb   9 months ago   13.3kB
```

La imagen `nginx:1.25` ahora está en tu máquina local. No necesitas volver a descargarla.

### 4.4 Comparar tamaños de imagen

Docker Hub ofrece diferentes variantes de la misma imagen para diversos propósitos. La variante Alpine utiliza Alpine Linux como sistema operativo base, que es una distribución minimalista diseñada específicamente para contenedores. Esto resulta en imágenes significativamente más pequeñas que ocupan menos espacio en disco y se descargan más rápido, aunque con menos herramientas preinstaladas.

```powershell
docker pull nginx:1.25-alpine
docker images nginx
```

**Salida esperada:**
```
REPOSITORY   TAG          IMAGE ID       CREATED       SIZE
nginx        1.25         a6bd71f48f68   2 weeks ago   187MB
nginx        1.25-alpine  2bc7edbc3cf2   2 weeks ago   43MB
```

La versión `alpine` es mucho más pequeña (43MB vs 187MB) porque usa Alpine Linux como base.

## **Paso 5: Ejecutar el primer contenedor Nginx**

Ahora que tenemos la imagen de Nginx descargada y almacenada localmente en nuestro sistema, ha llegado el momento más emocionante del tutorial: crear y ejecutar nuestro primer contenedor Nginx funcional. Este paso es absolutamente fundamental en tu aprendizaje porque aquí aprenderás los parámetros esenciales del comando `docker run`, que es probablemente el comando más importante de todo Docker. Comprenderás en profundidad conceptos críticos como el mapeo de puertos (que permite que tu navegador se comunique con el contenedor), la asignación de nombres descriptivos a los contenedores, y el modo de ejecución en segundo plano que libera tu terminal. Estos son conceptos que usarás constantemente en cualquier proyecto con Docker.

### 5.1 ¿Qué vamos a hacer?

En este subpaso crearemos un contenedor completamente funcional a partir de la imagen nginx:1.25 que descargamos previamente, y lo configuraremos para que Nginx sea accesible desde cualquier navegador web de tu computadora a través del puerto 8080. Esto significa que podrás abrir Chrome, Firefox o Edge y ver la página de bienvenida de Nginx sirviendo contenido real.

### 5.2 El comando completo

```powershell
docker run -d --name nginx-basico -p 8080:80 nginx:1.25
```

### 5.3 Explicación detallada de cada parte

Cada uno de los parámetros que incluimos en el comando `docker run` tiene un propósito específico y bien definido. Comprender exactamente qué hace cada parámetro te dará el poder de personalizar la ejecución de contenedores según las necesidades específicas de cada proyecto, ya sea cambiando puertos, nombres, o añadiendo opciones adicionales que veremos más adelante.

| Parámetro | ¿Qué hace? | ¿Por qué es necesario? |
|-----------|------------|------------------------|
| `docker run` | Crea y ejecuta un contenedor | Comando base |
| `-d` | Modo "detached" (segundo plano) | Sin esto, la terminal queda bloqueada mostrando logs |
| `--name nginx-basico` | Asigna el nombre "nginx-basico" | Sin esto, Docker genera nombres aleatorios |
| `-p 8080:80` | Mapea puerto 8080 (tu PC) al puerto 80 (contenedor) | Sin esto, no podrías acceder desde el navegador |
| `nginx:1.25` | La imagen a usar | Le dice a Docker qué software ejecutar |

### 5.4 Entendiendo el mapeo de puertos

El mapeo de puertos es un concepto fundamental que debes dominar para trabajar efectivamente con Docker. Básicamente, crea un túnel de comunicación entre un puerto de tu máquina Windows y un puerto dentro del contenedor aislado. Sin este mapeo, el contenedor estaría completamente incomunicado del exterior porque Docker aísla la red del contenedor por defecto. El formato siempre es `-p PUERTO_HOST:PUERTO_CONTENEDOR`.

```
    TU PC (Windows)                     CONTENEDOR
    ───────────────                     ──────────
                                        
    localhost:8080  ◄─────────────────► Puerto 80
         │                                  │
         │          -p 8080:80              │
         │                                  │
    Tu navegador                       Nginx
    accede aquí                        escucha aquí
```

**¿Por qué no usar el puerto 80 directamente?**
- En Windows, el puerto 80 puede estar ocupado por otros servicios
- El puerto 8080 es comúnmente usado para desarrollo
- Puedes tener múltiples contenedores en diferentes puertos

### 5.5 Verificar que el contenedor está corriendo

Después de ejecutar el comando `docker run`, es fundamental verificar que el contenedor realmente se inició correctamente y está en estado de ejecución. El comando `docker ps` (process status) muestra una tabla con todos los contenedores que actualmente están corriendo en tu sistema, proporcionándote información valiosa como el ID del contenedor, la imagen utilizada, el tiempo que lleva ejecutándose, y los puertos mapeados.

```powershell
docker ps
```

**Salida esperada:**
```
CONTAINER ID   IMAGE        COMMAND                  CREATED          STATUS          PORTS                  NAMES
a1b2c3d4e5f6   nginx:1.25   "/docker-entrypoint.…"   10 seconds ago   Up 9 seconds    0.0.0.0:8080->80/tcp   nginx-basico
```

**Interpretación de cada columna:**

| Columna | Significado |
|---------|-------------|
| `CONTAINER ID` | Identificador único del contenedor |
| `IMAGE` | Imagen de la que se creó |
| `COMMAND` | Comando que está ejecutando |
| `CREATED` | Cuándo se creó |
| `STATUS` | Estado actual (`Up` = corriendo) |
| `PORTS` | Mapeo de puertos |
| `NAMES` | Nombre del contenedor |

### 5.6 Probar que Nginx funciona

Existen dos formas principales de verificar que Nginx está sirviendo contenido correctamente: usando un navegador web gráfico o usando comandos de terminal. Ambos métodos son válidos y te mostrarán el mismo resultado. El navegador es más visual e intuitivo, mientras que los comandos de terminal son útiles para verificaciones automatizadas o cuando trabajas en servidores remotos sin interfaz gráfica.

**Opción 1: Desde el navegador**

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

Verás la página de bienvenida de Nginx con el mensaje:

```
Welcome to nginx!
If you see this page, the nginx web server is successfully installed and working.
```

## **Paso 6: Gestión del contenedor**

Una vez que tienes contenedores ejecutándose en tu sistema, es absolutamente esencial que sepas cómo administrarlos correctamente durante todo su ciclo de vida. La gestión de contenedores incluye múltiples operaciones fundamentales: visualizar los logs del servidor para diagnosticar problemas y entender qué está sucediendo internamente, acceder al interior del contenedor para explorar su sistema de archivos o modificar configuraciones en tiempo real, y controlar el ciclo de vida completo del contenedor (detenerlo cuando no lo necesites, reiniciarlo después de cambios, o eliminarlo cuando ya no sea útil). Dominar estas operaciones es fundamental para cualquier administrador de sistemas o desarrollador que trabaje con Docker.

### 6.1 Ver los logs del servidor

Los logs son registros de texto que Nginx genera automáticamente durante su ejecución, documentando cada petición que recibe, cada error que encuentra, y cada evento significativo que ocurre. Estos logs son tu principal herramienta de diagnóstico cuando algo no funciona como esperabas, ya que te permiten ver exactamente qué está sucediendo dentro del contenedor sin necesidad de entrar en él.

```powershell
docker logs nginx-basico
```

**Salida típica:**
```
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Configuration complete; ready for start up
2024/01/15 10:00:00 [notice] 1#1: nginx/1.25.3
2024/01/15 10:00:00 [notice] 1#1: start worker processes
172.17.0.1 - - [15/Jan/2024:10:00:05 +0000] "GET / HTTP/1.1" 200 615 "-" "Mozilla/5.0..."
```

**Para seguir los logs en tiempo real:**

```powershell
docker logs -f nginx-basico
```

El flag `-f` (follow) hace que los nuevos logs aparezcan automáticamente. Presiona `Ctrl+C` para salir.

### 6.2 Entrar dentro del contenedor

Docker te permite acceder directamente al sistema de archivos interno del contenedor como si estuvieras conectándote a otro ordenador por SSH. Esta capacidad es extremadamente útil para explorar la estructura interna de la imagen, verificar que los archivos de configuración son correctos, comprobar permisos, o depurar problemas que no puedes diagnosticar solo con los logs externos.

```powershell
docker exec -it nginx-basico bash
```

**Desglose:**

| Parte | Significado |
|-------|-------------|
| `docker exec` | Ejecuta un comando en un contenedor existente |
| `-i` | Modo interactivo (mantiene STDIN abierto) |
| `-t` | Asigna una pseudo-terminal |
| `nginx-basico` | Nombre del contenedor |
| `bash` | El comando a ejecutar (el shell bash) |

**Ahora estás DENTRO del contenedor.** El prompt cambiará a:
```
root@a1b2c3d4e5f6:/#
```

**Comandos para explorar dentro del contenedor:**

```bash
# Ver la versión de Nginx
nginx -v
# Salida: nginx version: nginx/1.25.3

# Ver el contenido del directorio web
ls -la /usr/share/nginx/html/
# Salida: 50x.html  index.html

# Ver el archivo index.html
cat /usr/share/nginx/html/index.html

# Ver la configuración principal
cat /etc/nginx/nginx.conf

# Salir del contenedor (IMPORTANTE)
exit
```

**Importante:** Cuando escribes `exit`, sales del contenedor pero el contenedor sigue corriendo.

### 6.3 Ciclo de vida del contenedor

Este diagrama visual representa los diferentes estados por los que puede pasar un contenedor Docker durante su existencia, y qué comandos provocan las transiciones entre estados. Entender profundamente este ciclo de vida te ayudará a gestionar correctamente tus contenedores, saber cuándo usar cada comando, y evitar errores comunes como intentar eliminar un contenedor que está corriendo.

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

Los siguientes comandos te permiten controlar completamente el estado y el ciclo de vida de tus contenedores Docker. Son operaciones básicas pero fundamentales que usarás constantemente en tu trabajo diario. Es importante que los practiques y memorices, ya que son la base de toda gestión de contenedores en cualquier entorno de desarrollo o producción.

**Detener el contenedor:**
```powershell
docker stop nginx-basico
```

**Verificar que está detenido:**
```powershell
docker ps -a
```
El STATUS mostrará `Exited (0)`.

**Iniciar el contenedor detenido:**
```powershell
docker start nginx-basico
```

**Reiniciar el contenedor:**
```powershell
docker restart nginx-basico
```

**Eliminar el contenedor (primero debe estar detenido):**
```powershell
docker stop nginx-basico
docker rm nginx-basico
```

**Eliminar el contenedor forzadamente (aunque esté corriendo):**
```powershell
docker rm -f nginx-basico
```

## **Paso 7: Montar volúmenes - Servir contenido propio**

Hasta este momento, cada vez que accedes a tu servidor Nginx, este muestra únicamente su página de bienvenida por defecto que viene incluida dentro de la imagen Docker. Sin embargo, el verdadero objetivo de un servidor web es servir TU propio contenido: tus páginas HTML, tus hojas de estilo CSS, tus scripts JavaScript y tus imágenes. Para lograr esto sin tener que copiar archivos manualmente dentro del contenedor cada vez que haces un cambio, Docker proporciona una característica extraordinariamente útil llamada volúmenes. Un volumen crea una conexión directa entre una carpeta de tu sistema Windows y una carpeta dentro del contenedor, sincronizando su contenido en tiempo real. Los cambios que hagas en Windows se reflejan instantáneamente en el contenedor, y lo más importante: tus archivos persisten de forma segura en tu disco aunque elimines el contenedor.

### 7.1 El problema actual

El navegador muestra siempre la misma página por defecto de Nginx con el mensaje "Welcome to nginx!". Si quisieras mostrar tu propio sitio web personalizado, la única alternativa sin volúmenes sería copiar archivos manualmente dentro del contenedor cada vez que haces un cambio, lo cual es extremadamente incómodo e impráctico para desarrollo.

**Problemas de este enfoque:**
- Si eliminas el contenedor, pierdes todo tu trabajo
- No puedes usar editores de Windows como VS Code
- Es incómodo trabajar dentro del contenedor

### 7.2 La solución: Volúmenes

Un volumen es el mecanismo que Docker proporciona para conectar y sincronizar una carpeta de tu sistema operativo Windows con una carpeta específica dentro del contenedor. Cuando montas un volumen, los archivos existen físicamente en tu disco duro de Windows, pero el contenedor puede acceder a ellos y leerlos como si estuvieran dentro de su propio sistema de archivos, en tiempo real y sin delays.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│   TU PC WINDOWS                              CONTENEDOR DOCKER              │
│   ══════════════                             ═════════════════              │
│                                                                             │
│   C:\nginx-proyecto\html\                    /usr/share/nginx/html/         │
│   ├── index.html    ◄═══════════════════════► ├── index.html               │
│   ├── styles.css    ◄═══ SINCRONIZADO ══════► ├── styles.css               │
│   └── imagenes\     ◄═══════════════════════► └── imagenes\                │
│                                                                             │
│   Editas con VS Code                         Nginx lee y sirve             │
│                                              al navegador                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 7.3 Crear la estructura del proyecto

En este subpaso crearemos la estructura de carpetas en tu disco de Windows que utilizaremos para almacenar todos los archivos del proyecto. Esta estructura organizada es importante para mantener separados los archivos HTML de otras configuraciones que añadiremos más adelante, siguiendo buenas prácticas de organización de proyectos.

**Con PowerShell:**

```powershell
New-Item -ItemType Directory -Path C:\nginx-proyecto -Force
New-Item -ItemType Directory -Path C:\nginx-proyecto\html -Force
```

**Verificar:**
```powershell
Get-ChildItem C:\nginx-proyecto
```

### 7.4 Crear un archivo HTML de prueba

Ahora crearemos un archivo HTML personalizado que servirá como demostración de que el volumen funciona correctamente. Este archivo reemplazará la página por defecto de Nginx y te permitirá verificar visualmente que Docker está sirviendo contenido desde tu carpeta de Windows en lugar de usar sus archivos internos predeterminados.

Abre el Bloc de notas o VS Code y crea el archivo `C:\nginx-proyecto\html\index.html`:

```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Primera Página con Nginx</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        h1 {
            color: #667eea;
            margin-bottom: 20px;
        }
        p {
            color: #666;
            line-height: 1.6;
        }
        .success {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>¡Nginx con Docker funciona!</h1>
        <p>Esta página se está sirviendo desde un contenedor Docker.</p>
        <p>El archivo está en tu disco de Windows en:</p>
        <code>C:\nginx-proyecto\html\index.html</code>
        <div class="success">
            ✅ El volumen está correctamente montado
        </div>
    </div>
</body>
</html>
```

**O créalo con PowerShell:**

```powershell
@"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mi Primera Página con Nginx</title>
</head>
<body>
    <h1>¡Nginx con Docker funciona!</h1>
    <p>Esta página se sirve desde un contenedor Docker.</p>
</body>
</html>
"@ | Out-File -FilePath C:\nginx-proyecto\html\index.html -Encoding UTF8
```

### 7.5 Ejecutar Nginx con volumen montado

Este es el comando clave de este paso: ejecutaremos Nginx añadiendo el parámetro `-v` que indica a Docker que debe montar un volumen. Este parámetro conecta tu carpeta local de Windows con la carpeta del contenedor donde Nginx busca los archivos web, haciendo que cualquier archivo que coloques en Windows esté inmediatamente disponible.

Primero, elimina el contenedor anterior si existe:

```powershell
docker rm -f nginx-basico
```

Ahora ejecuta con el volumen:

```powershell
docker run -d --name nginx-web -p 8080:80 -v C:\nginx-proyecto\html:/usr/share/nginx/html:ro nginx:1.25
```

**Desglose del nuevo parámetro:**

| Parte | Significado |
|-------|-------------|
| `-v` | Indica que vamos a montar un volumen |
| `C:\nginx-proyecto\html` | Ruta en Windows (origen) |
| `:` | Separador |
| `/usr/share/nginx/html` | Ruta en el contenedor (destino) |
| `:ro` | Read-only (el contenedor solo puede leer, no escribir) |

### 7.6 Probar el contenido propio

Ha llegado el momento de la verdad: vamos a verificar que el volumen funciona correctamente accediendo a la URL de tu servidor Nginx. Si todo está configurado bien, deberías ver tu página HTML personalizada con los estilos CSS aplicados, en lugar de la aburrida página por defecto de Nginx que veíamos antes.

Abre el navegador y ve a: `http://localhost:8080`

Deberías ver tu página personalizada con el mensaje "¡Nginx con Docker funciona!".

### 7.7 Modificar en tiempo real

Una de las ventajas más poderosas de los volúmenes es la sincronización instantánea: cualquier cambio que hagas en los archivos de Windows se refleja inmediatamente en el contenedor sin necesidad de reiniciarlo ni ejecutar ningún comando adicional. Esto permite un flujo de desarrollo extraordinariamente ágil y productivo.

1. Abre `C:\nginx-proyecto\html\index.html` en VS Code o Notepad
2. Cambia el texto del `<h1>` a "¡Hola Mundo desde Nginx!"
3. Guarda el archivo
4. Refresca el navegador (F5)

El cambio aparece inmediatamente sin reiniciar el contenedor.

## **Paso 8: Configuración personalizada de Nginx**

Nginx es un servidor web extremadamente configurable que se adapta a prácticamente cualquier necesidad mediante archivos de configuración de texto plano con una sintaxis bien definida. La configuración por defecto que viene con la imagen Docker es perfectamente funcional para pruebas básicas, pero está muy limitada para proyectos reales de producción. Para sacar el máximo provecho de Nginx, necesitarás personalizar aspectos críticos como la compresión gzip para reducir el tamaño de las respuestas, la configuración de caché del navegador para mejorar los tiempos de carga, los tipos MIME para que el navegador interprete correctamente cada archivo, las páginas de error personalizadas para una mejor experiencia de usuario, y muchas otras opciones avanzadas.

### 8.1 Estructura del archivo nginx.conf

El archivo principal de configuración de Nginx utiliza una estructura jerárquica basada en bloques anidados delimitados por llaves. Cada bloque define un contexto específico de configuración: el contexto global afecta a todo el servidor, el bloque events controla las conexiones, el bloque http agrupa la configuración web, y dentro puede haber múltiples bloques server para diferentes sitios.

```nginx
# Configuración global
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;

# Bloque de eventos
events {
    worker_connections  1024;
}

# Bloque HTTP
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    # Bloque de servidor (virtual host)
    server {
        listen       80;
        server_name  localhost;

        # Bloque de ubicación
        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }
    }
}
```

### 8.2 Crear configuración personalizada

Ahora vamos a crear nuestro propio archivo de configuración que incluirá optimizaciones profesionales como compresión gzip para reducir el ancho de banda y páginas de error personalizadas. Esta configuración representa un punto de partida sólido para proyectos reales.

Crea la carpeta para la configuración:

```powershell
New-Item -ItemType Directory -Path C:\nginx-proyecto\conf -Force
```

Crea el archivo `C:\nginx-proyecto\conf\default.conf`:

```nginx
server {
    listen 80;
    server_name localhost;

    # Directorio raíz
    root /usr/share/nginx/html;
    index index.html index.htm;

    # Habilitar compresión gzip
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml;
    gzip_min_length 1000;

    # Página principal
    location / {
        try_files $uri $uri/ =404;
    }

    # Páginas de error personalizadas
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
}
```

### 8.3 Crear página de error 404

Cuando un visitante intenta acceder a una URL que no existe en tu sitio web, Nginx muestra una página de error 404 por defecto que es técnica y poco amigable. Crear una página de error personalizada mejora significativamente la experiencia del usuario, ofreciendo una interfaz visualmente coherente con tu sitio y proporcionando navegación útil para encontrar lo que buscan.

Crea el archivo `C:\nginx-proyecto\html\404.html`:

```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>404 - Página no encontrada</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: #1a1a2e;
            color: white;
        }
        .error-container {
            text-align: center;
        }
        h1 {
            font-size: 120px;
            margin: 0;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        p {
            font-size: 24px;
            color: #888;
        }
        a {
            color: #667eea;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>404</h1>
        <p>¡Ups! La página que buscas no existe.</p>
        <a href="/">← Volver al inicio</a>
    </div>
</body>
</html>
```

### 8.4 Ejecutar con configuración personalizada

Ahora que tenemos tanto nuestra página HTML personalizada como nuestro archivo de configuración de Nginx listo, vamos a ejecutar un nuevo contenedor que utilice ambos mediante volúmenes. Este contenedor montará dos volúmenes diferentes: uno para el contenido web y otro para la configuración, sobrescribiendo los valores por defecto de la imagen original.

```powershell
docker rm -f nginx-web

docker run -d --name nginx-custom -p 8080:80 `
    -v C:\nginx-proyecto\html:/usr/share/nginx/html:ro `
    -v C:\nginx-proyecto\conf\default.conf:/etc/nginx/conf.d/default.conf:ro `
    nginx:1.25
```

### 8.5 Verificar la configuración

Antes de confiar en que tu sitio funcionará correctamente, es una buena práctica ejecutar un test de sintaxis de la configuración de Nginx. Este comando lee todos los archivos de configuración y verifica que no hay errores de sintaxis que impedirían el arranque del servidor. Es especialmente útil cuando haces cambios manuales en los archivos de configuración.

```powershell
docker exec nginx-custom nginx -t
```

**Salida esperada:**
```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

### 8.6 Probar la página 404

Vamos a verificar que nuestra página de error 404 personalizada funciona correctamente. Para ello, accederemos intencionalmente a una URL que no existe en nuestro sitio web. Si la configuración está correcta, veremos nuestra página de error diseñada en lugar del mensaje genérico y poco amigable que muestra Nginx por defecto.

Abre: `http://localhost:8080/pagina-inexistente`

Deberías ver tu página 404 personalizada.

## **Paso 9: Crear una imagen personalizada con Dockerfile**

Un Dockerfile es un archivo de texto especial que contiene una serie de instrucciones que Docker utiliza para construir automáticamente una imagen personalizada desde cero. Hasta ahora hemos estado montando volúmenes para servir nuestro contenido, lo cual es perfecto para desarrollo porque permite cambios en tiempo real. Sin embargo, para despliegues en producción, el enfoque recomendado es empaquetar todo tu sitio web directamente dentro de la imagen Docker. Esto crea una imagen autocontenida e inmutable que puedes distribuir a cualquier servidor del mundo, ejecutar con un simple comando, y tener la certeza absoluta de que funcionará exactamente igual que en tu máquina de desarrollo.

### 9.1 ¿Por qué crear una imagen propia?

Es fundamental entender la diferencia entre el enfoque de volúmenes que hemos usado hasta ahora y el enfoque de imágenes personalizadas que aprenderemos en este paso. Los volúmenes son ideales para desarrollo local porque permiten hacer cambios instantáneos sin reconstruir nada. Sin embargo, para producción conviene tener todo el contenido empaquetado en una imagen autocontenida, portable, versionable y reproducible.

| Volúmenes (desarrollo) | Imagen propia (producción) |
|------------------------|----------------------------|
| Cambios en tiempo real | Contenido fijo e inmutable |
| Depende de archivos externos | Todo incluido en la imagen |
| No se puede distribuir fácilmente | Se puede subir a registros |
| Perfecto para desarrollo | Perfecto para producción |

### 9.2 Crear el Dockerfile

El Dockerfile es la receta que Docker sigue para construir tu imagen personalizada. Cada línea del archivo es una instrucción que Docker ejecuta secuencialmente, y cada instrucción crea una nueva "capa" en la imagen final. Estas capas se almacenan en caché, por lo que si solo cambias el código HTML pero no la configuración base, Docker reutiliza las capas anteriores acelerando las builds.

Crea el archivo `C:\nginx-proyecto\Dockerfile`:

```dockerfile
# Imagen base
FROM nginx:1.25-alpine

# Metadatos
LABEL maintainer="tu@email.com"
LABEL description="Mi sitio web con Nginx"
LABEL version="1.0"

# Copiar archivos del sitio web
COPY html/ /usr/share/nginx/html/

# Copiar configuración personalizada
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# El puerto que expone Nginx
EXPOSE 80

# Comando por defecto (heredado de la imagen base)
CMD ["nginx", "-g", "daemon off;"]
```

**Explicación de cada instrucción:**

| Instrucción | Significado |
|-------------|-------------|
| `FROM nginx:1.25-alpine` | Usa nginx:1.25-alpine como base |
| `LABEL` | Añade metadatos a la imagen |
| `COPY html/ ...` | Copia tu carpeta html al contenedor |
| `COPY conf/...` | Copia tu configuración al contenedor |
| `EXPOSE 80` | Documenta que el contenedor usa el puerto 80 |
| `CMD` | Comando que se ejecuta al iniciar el contenedor |

### 9.3 Construir la imagen

El comando `docker build` es el motor que transforma tu Dockerfile en una imagen ejecutable. Este comando lee el Dockerfile línea por línea, ejecuta cada instrucción en orden, y al finalizar genera una nueva imagen Docker almacenada localmente con el nombre y etiqueta que especifiques. Esta imagen contiene todo tu contenido empaquetado de forma permanente.

```powershell
cd C:\nginx-proyecto
docker build -t mi-sitio-nginx:1.0 .
```

**Desglose:**

| Parte | Significado |
|-------|-------------|
| `docker build` | Comando para construir una imagen |
| `-t mi-sitio-nginx:1.0` | Nombre y tag de la imagen |
| `.` | Directorio donde está el Dockerfile (actual) |

**Salida esperada:**
```
[+] Building 2.5s (9/9) FINISHED
 => [internal] load build definition from Dockerfile
 => [internal] load .dockerignore
 => [internal] load metadata for docker.io/library/nginx:1.25-alpine
 => [1/4] FROM docker.io/library/nginx:1.25-alpine
 => [2/4] COPY html/ /usr/share/nginx/html/
 => [3/4] COPY conf/default.conf /etc/nginx/conf.d/default.conf
 => exporting to image
 => => naming to docker.io/library/mi-sitio-nginx:1.0
```

### 9.4 Verificar la imagen creada

Después de que el proceso de construcción finalice exitosamente, es importante verificar que tu imagen personalizada aparece en la lista de imágenes locales de Docker. El comando `docker images` te mostrará el nombre de la imagen, su etiqueta de versión, el tamaño total en disco, y cuándo fue creada, confirmando que está lista para usar.

```powershell
docker images mi-sitio-nginx
```

**Salida esperada:**
```
REPOSITORY       TAG       IMAGE ID       CREATED          SIZE
mi-sitio-nginx   1.0       abc123def456   30 seconds ago   43.5MB
```

### 9.5 Ejecutar un contenedor desde tu imagen

Ahora viene la parte más satisfactoria: ejecutar tu imagen personalizada como un contenedor funcional. A diferencia de antes, esta vez no necesitas montar ningún volumen porque todo el contenido (HTML, CSS, configuración) ya está empaquetado permanentemente dentro de la imagen. Simplemente la ejecutas y funciona inmediatamente.

```powershell
docker rm -f nginx-custom

docker run -d --name mi-sitio -p 8080:80 mi-sitio-nginx:1.0
```

Abre `http://localhost:8080` para ver tu sitio.

### 9.6 Ventajas de esta aproximación

Crear tu propia imagen Docker transforma tu sitio web en un paquete portátil y autosuficiente. Ahora puedes copiar esta imagen a cualquier servidor del mundo que tenga Docker instalado, ejecutarla con un solo comando, y obtendrás exactamente el mismo resultado que en tu máquina de desarrollo, sin necesidad de configurar nada ni copiar archivos adicionales.

- **Portabilidad:** La imagen funciona igual en cualquier máquina
- **Versionado:** Puedes crear múltiples versiones (1.0, 1.1, 2.0...)
- **Distribución:** Puedes subir la imagen a Docker Hub o registros privados

## **Paso 10: Docker Compose - Orquestación básica**

Docker Compose es una herramienta complementaria a Docker que simplifica enormemente la gestión de aplicaciones que utilizan múltiples contenedores o configuraciones complejas. En lugar de memorizar y escribir largos comandos `docker run` con múltiples parámetros cada vez que quieres iniciar tu aplicación, Docker Compose te permite definir toda la configuración en un archivo YAML legible y versionable llamado `docker-compose.yml`. Este archivo actúa como la "receta" de tu infraestructura, describiendo qué imágenes usar, qué puertos exponer, qué volúmenes montar, y cómo se relacionan los servicios entre sí. Compose también facilita la gestión del ciclo de vida de todos los contenedores con comandos simples como `up` y `down`.

### 10.1 ¿Qué es Docker Compose?

Docker Compose resuelve el problema de tener que escribir comandos Docker largos y propensos a errores. En lugar de recordar todos los parámetros cada vez, defines la configuración una vez en un archivo YAML estructurado y legible. Este archivo puede versionarse en Git junto con tu código, facilitando la colaboración en equipo y la reproducibilidad del entorno.

**Sin Compose:**
```powershell
docker run -d --name nginx-web -p 8080:80 -v C:\nginx-proyecto\html:/usr/share/nginx/html:ro nginx:1.25
```

**Con Compose:** Todo definido en un archivo legible.

### 10.2 Crear el archivo docker-compose.yml

El archivo docker-compose.yml utiliza el formato YAML (Yet Another Markup Language) que es muy legible para humanos gracias a su estructura basada en indentación y pares clave-valor. En este archivo definirás cada servicio (contenedor) que forma parte de tu aplicación, junto con toda su configuración: imagen, puertos, volúmenes, variables de entorno, dependencias, y más.

Crea el archivo `C:\nginx-proyecto\docker-compose.yml`:

```yaml
version: '3.8'

services:
  web:
    image: nginx:1.25
    container_name: nginx-compose
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
      - ./conf/default.conf:/etc/nginx/conf.d/default.conf:ro
    restart: unless-stopped
```

**Explicación:**

| Campo | Significado |
|-------|-------------|
| `version` | Versión del formato de Compose |
| `services` | Lista de contenedores a ejecutar |
| `web` | Nombre del servicio |
| `image` | Imagen a usar |
| `container_name` | Nombre del contenedor |
| `ports` | Mapeo de puertos |
| `volumes` | Volúmenes a montar |
| `restart` | Política de reinicio |

### 10.3 Comandos de Docker Compose

Los siguientes comandos son el núcleo del flujo de trabajo con Docker Compose. Permiten gestionar todos los servicios definidos en tu archivo YAML con operaciones simples y unificadas. Un solo comando puede iniciar, detener o reiniciar múltiples contenedores simultáneamente, lo que simplifica enormemente la administración de aplicaciones complejas.

Primero, detén contenedores anteriores:
```powershell
docker rm -f nginx-web nginx-custom mi-sitio
```

**Iniciar servicios:**
```powershell
cd C:\nginx-proyecto
docker compose up -d
```

**Ver estado:**
```powershell
docker compose ps
```

**Ver logs:**
```powershell
docker compose logs -f
```

**Detener servicios:**
```powershell
docker compose down
```

### 10.4 Añadir múltiples servicios

Aquí es donde Docker Compose realmente demuestra su poder: la capacidad de definir y gestionar múltiples servicios relacionados en un solo archivo. En este ejemplo añadiremos un segundo servidor Nginx que servirá documentación, simulando un escenario real donde tienes tu sitio principal y un portal de documentación separado. Ambos servicios se gestionarán como una unidad cohesiva.

Modifica `docker-compose.yml`:

```yaml
version: '3.8'

services:
  web:
    image: nginx:1.25
    container_name: nginx-principal
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
      - ./conf/default.conf:/etc/nginx/conf.d/default.conf:ro
    restart: unless-stopped

  docs:
    image: nginx:1.25-alpine
    container_name: nginx-docs
    ports:
      - "8081:80"
    volumes:
      - ./docs:/usr/share/nginx/html:ro
    restart: unless-stopped
```

### 10.5 Crear contenido para el segundo servicio

Cada servicio en Docker Compose es completamente independiente y puede tener su propio contenido, configuración y recursos. Para nuestro servicio de documentación, crearemos una carpeta separada con su propio archivo HTML. Esta separación mantiene el proyecto organizado y permite que diferentes equipos trabajen en diferentes servicios sin interferencias.

```powershell
New-Item -ItemType Directory -Path C:\nginx-proyecto\docs -Force
```

Crea `C:\nginx-proyecto\docs\index.html`:

```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Documentación</title>
    <style>
        body { 
            font-family: sans-serif; 
            max-width: 800px; 
            margin: 40px auto; 
            padding: 20px;
        }
        h1 { color: #2c3e50; }
    </style>
</head>
<body>
    <h1>📚 Documentación del Proyecto</h1>
    <p>Esta es la página de documentación servida en el puerto 8081.</p>
</body>
</html>
```

### 10.6 Ejecutar ambos servicios

Con Docker Compose, un solo comando es suficiente para iniciar, configurar y conectar todos los servicios definidos en tu archivo de configuración. Docker Compose lee el archivo YAML, crea una red virtual privada para que los servicios se comuniquen entre sí, y arranca cada contenedor con la configuración especificada, todo de forma automática y coordinada.

```powershell
docker compose up -d
```

**Verificar:**
```powershell
docker compose ps
```

**Salida esperada:**
```
NAME              IMAGE              STATUS          PORTS
nginx-docs        nginx:1.25-alpine  Up 10 seconds   0.0.0.0:8081->80/tcp
nginx-principal   nginx:1.25         Up 10 seconds   0.0.0.0:8080->80/tcp
```

Ahora tienes:
- `http://localhost:8080` → Sitio principal
- `http://localhost:8081` → Documentación

## **Paso 11: Nginx como proxy inverso**

Un proxy inverso es un patrón arquitectónico extremadamente importante en sistemas web modernos donde un servidor Nginx (u otro software similar) actúa como punto de entrada único que recibe todas las peticiones de los clientes y las distribuye inteligentemente a diferentes servidores backend según diversos criterios como la URL solicitada, el dominio, cookies, o cabeceras HTTP. Esta configuración es la base de arquitecturas de microservicios y ofrece múltiples beneficios: centralizar la terminación SSL/TLS en un solo punto, ocultar la infraestructura interna de los usuarios, y facilitar el mantenimiento sin interrumpir el servicio.

### 11.1 ¿Qué es un proxy inverso?

Un proxy inverso es un servidor intermediario que se sitúa entre los clientes (navegadores) y los servidores backend reales. El cliente nunca se comunica directamente con los servidores internos; todas las peticiones pasan primero por el proxy, que decide a qué servidor backend enviar cada petición basándose en reglas configuradas, como la ruta de la URL o el dominio solicitado.

```
                                    ┌─────────────┐
                                    │  Servicio A │
                                    │  (puerto    │
┌──────────┐      ┌─────────┐      │   interno)  │
│ Navegador│─────►│  Nginx  │─────►├─────────────┤
│          │◄─────│  Proxy  │◄─────│  Servicio B │
└──────────┘      └─────────┘      │  (puerto    │
                                    │   interno)  │
                                    └─────────────┘
```

### 11.2 Configurar Nginx como proxy

En este subpaso crearemos un archivo de configuración de Nginx que define cómo el proxy debe enrutar las peticiones entrantes. Usaremos bloques `upstream` para definir los servidores backend y bloques `location` para especificar qué peticiones van a cada backend. Las peticiones a `/docs/` irán al servicio de documentación, y todas las demás al sitio principal.

Crea `C:\nginx-proyecto\conf\proxy.conf`:

```nginx
upstream backend_principal {
    server web:80;
}

upstream backend_docs {
    server docs:80;
}

server {
    listen 80;
    server_name localhost;

    # Redirigir /docs a servicio de documentación
    location /docs/ {
        proxy_pass http://backend_docs/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # Todo lo demás al servicio principal
    location / {
        proxy_pass http://backend_principal;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 11.3 Actualizar docker-compose.yml

Modificamos el archivo de Docker Compose para añadir un tercer servicio que actúa como proxy inverso. Este nuevo servicio será el único que expone puertos al exterior, mientras que los servicios web y docs se vuelven completamente internos y solo accesibles a través del proxy. Esta arquitectura mejora la seguridad y centraliza el control de acceso.

```yaml
version: '3.8'

services:
  proxy:
    image: nginx:1.25-alpine
    container_name: nginx-proxy
    ports:
      - "80:80"
    volumes:
      - ./conf/proxy.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - web
      - docs
    restart: unless-stopped

  web:
    image: nginx:1.25
    container_name: nginx-web-interno
    volumes:
      - ./html:/usr/share/nginx/html:ro
    # No expone puertos al exterior, solo accesible por el proxy

  docs:
    image: nginx:1.25-alpine
    container_name: nginx-docs-interno
    volumes:
      - ./docs:/usr/share/nginx/html:ro
    # No expone puertos al exterior, solo accesible por el proxy
```

### 11.4 Ejecutar la arquitectura con proxy

Ahora que hemos configurado nuestra arquitectura de proxy inverso, vamos a reiniciar todos los servicios para aplicar los cambios. Docker Compose detectará las modificaciones en la configuración, detendrá los contenedores existentes, creará los nuevos según la configuración actualizada, y los iniciará en el orden correcto respetando las dependencias definidas.

```powershell
docker compose down
docker compose up -d
```

**Ahora:**
- `http://localhost/` → Sitio principal
- `http://localhost/docs/` → Documentación

Todo a través de un único puerto 80.

## **Paso 12: Limpieza y buenas prácticas**

Después de experimentar extensivamente con Docker a lo largo de este tutorial, es fundamental que aprendas a mantener tu entorno limpio, eficiente y seguro. Docker acumula progresivamente imágenes descargadas, contenedores detenidos, volúmenes huérfanos y caché de construcción que ocupan espacio valioso en tu disco duro. Además, para despliegues en producción, existen buenas prácticas de seguridad y rendimiento que debes conocer y aplicar. Este paso final del tutorial te proporciona todas las herramientas y conocimientos necesarios para mantener un entorno Docker profesional, limpio y optimizado, ya sea en tu máquina de desarrollo o en servidores de producción.

### 12.1 Detener todos los contenedores del proyecto

Docker Compose mantiene un registro de todos los recursos que ha creado (contenedores, redes, volúmenes) y puede limpiarlos todos con un solo comando. El comando `down` detiene y elimina todos los contenedores definidos en tu archivo docker-compose.yml, junto con la red virtual que Docker Compose creó automáticamente para conectarlos.

```powershell
cd C:\nginx-proyecto
docker compose down
```

### 12.2 Limpiar contenedores huérfanos

Con el tiempo, especialmente durante el desarrollo y experimentación, se acumulan contenedores detenidos que ya no necesitas pero que siguen ocupando espacio en disco. El comando `prune` identifica y elimina automáticamente todos los contenedores que no están actualmente en ejecución, liberando los recursos asociados a ellos.

```powershell
docker container prune
```

### 12.3 Limpiar imágenes no utilizadas

Las imágenes Docker pueden ocupar cientos de megabytes o incluso gigabytes de espacio en disco. Durante el desarrollo, es común descargar múltiples versiones de imágenes o generar imágenes intermedias que ya no necesitas. Este comando elimina las imágenes que no tienen ningún contenedor asociado, recuperando espacio valioso.

```powershell
docker image prune
```

**Para eliminar TODAS las imágenes no usadas (incluidas las etiquetadas):**
```powershell
docker image prune -a
```

### 12.4 Limpieza completa

Cuando necesitas recuperar la mayor cantidad de espacio posible o quieres empezar con un entorno Docker completamente limpio, este comando nuclear elimina absolutamente todo lo que no esté actualmente en uso: contenedores detenidos, imágenes sin usar, redes huérfanas, y toda la caché de construcción acumulada.

```powershell
docker system prune -a
```

⚠️ **Precaución:** Esto elimina TODO lo que no esté en uso.

### 12.5 Ver uso de disco

Antes de ejecutar comandos de limpieza agresivos, es prudente revisar exactamente cuánto espacio está consumiendo Docker y en qué categorías. Este comando te proporciona un resumen detallado del uso de disco dividido por tipo de recurso (imágenes, contenedores, volúmenes, caché), ayudándote a tomar decisiones informadas sobre qué limpiar.

```powershell
docker system df
```

**Salida ejemplo:**
```
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          5         2         850MB     500MB (58%)
Containers      3         1         100MB     80MB (80%)
Local Volumes   2         1         50MB      25MB (50%)
Build Cache     10        0         200MB     200MB (100%)
```

### 12.6 Buenas prácticas de seguridad

Las siguientes recomendaciones representan el estándar de la industria para despliegues de Nginx en contenedores Docker en entornos de producción. Aplicar estas prácticas reduce significativamente la superficie de ataque, minimiza el riesgo de vulnerabilidades, y asegura que tu infraestructura siga los principios de seguridad por defecto.

1. **Usar imágenes Alpine:** Menos paquetes = menos vulnerabilidades
2. **Ejecutar como non-root:**
   ```dockerfile
   FROM nginx:1.25-alpine
   RUN chown -R nginx:nginx /usr/share/nginx/html
   USER nginx
   ```
3. **Montar volúmenes como solo lectura (`:ro`)**
4. **Mantener imágenes actualizadas**
5. **No exponer puertos innecesarios**

### 12.7 Comandos útiles de referencia

Esta tabla de referencia rápida resume los comandos Docker y Docker Compose más importantes que has aprendido a lo largo de este tutorial. Guárdala como chuleta para tu trabajo diario con contenedores, ya que estos comandos forman la base de cualquier flujo de trabajo profesional con Docker en desarrollo o producción.

| Comando | Descripción |
|---------|-------------|
| `docker run -d -p 8080:80 nginx` | Ejecutar Nginx básico |
| `docker ps` | Ver contenedores corriendo |
| `docker logs -f <nombre>` | Ver logs en tiempo real |
| `docker exec -it <nombre> bash` | Entrar al contenedor |
| `docker stop <nombre>` | Detener contenedor |
| `docker rm -f <nombre>` | Eliminar contenedor |
| `docker compose up -d` | Iniciar servicios |
| `docker compose down` | Detener servicios |
| `docker build -t <nombre> .` | Construir imagen |

## **Resumen del tutorial**

En este tutorial has aprendido:

1. ✅ **Verificar Docker** en Windows
2. ✅ **Fundamentos de Docker:** imágenes, contenedores, volúmenes
3. ✅ **Conceptos de Nginx:** arquitectura y configuración
4. ✅ **Descargar imágenes** desde Docker Hub
5. ✅ **Ejecutar contenedores** con mapeo de puertos
6. ✅ **Gestionar contenedores:** logs, exec, ciclo de vida
7. ✅ **Montar volúmenes** para contenido propio
8. ✅ **Configurar Nginx** con archivos personalizados
9. ✅ **Crear imágenes** con Dockerfile
10. ✅ **Usar Docker Compose** para orquestación
11. ✅ **Configurar proxy inverso**
12. ✅ **Limpieza** y buenas prácticas

**Siguiente paso sugerido:** Experimenta configurando HTTPS con certificados SSL usando certbot.

## **Recursos adicionales**

- [Documentación oficial de Nginx](https://nginx.org/en/docs/)
- [Documentación de Docker](https://docs.docker.com/)
- [Docker Hub - Imagen oficial de Nginx](https://hub.docker.com/_/nginx)
- [Docker Compose reference](https://docs.docker.com/compose/compose-file/)
