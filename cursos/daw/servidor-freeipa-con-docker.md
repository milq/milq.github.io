# Tutorial: Despliegue de Identidad Centralizada con FreeIPA y Docker

En este laboratorio práctico aprenderemos a implementar una solución de gestión de identidades (IdM) empresarial utilizando **FreeIPA**. En el mundo real, gestionar usuarios máquina por máquina es insostenible; por ello, los administradores de sistemas utilizan directorios centralizados como Active Directory o FreeIPA.

Para este ejercicio utilizaremos **Docker**. FreeIPA es un sistema complejo que integra múltiples servicios (LDAP, Kerberos, DNS, Apache, Certmonger). Instalarlo manualmente puede llevar horas y es propenso a errores. Docker nos permite encapsular toda esta complejidad en un contenedor preconfigurado, garantizando que el entorno de todos los alumnos sea idéntico y funcional desde el primer minuto. Aprenderemos a solucionar retos comunes, como la persistencia de datos y los permisos de `systemd` dentro de contenedores.

## Paso 1: Configurar el entorno del Servidor

**Introducción:**
El primer paso es definir la infraestructura de nuestro servidor. FreeIPA está diseñado para ejecutarse sobre distribuciones como RHEL o Rocky Linux, las cuales dependen fuertemente del sistema de inicio **systemd** para gestionar sus servicios internos. Aquí radica el desafío: los contenedores Docker estándar no suelen ejecutar systemd. Por eso, en este paso configuraremos un contenedor especial "privilegiado" que simule un sistema operativo completo. Además, definiremos **volúmenes**, que son espacios de almacenamiento que sobreviven al ciclo de vida del contenedor, asegurando que nuestra base de datos de usuarios no se borre si reiniciamos el servidor.

### 1.1 Preparación del espacio de trabajo

Antes de empezar a trabajar con contenedores, es fundamental mantener un orden en nuestro sistema de archivos. Al crear un directorio específico para el proyecto, aislamos nuestros archivos de configuración (`docker-compose.yml`) y los volúmenes de datos. Esto facilita la limpieza posterior y evita conflictos con otros proyectos.

> Ejecuta: `mkdir freeipa-lab` y accede con `cd freeipa-lab`.

### 1.2 Definición de la infraestructura (Docker Compose)

Este es el paso más crítico. Vamos a crear el archivo `docker-compose.yml`. A diferencia del tutorial original que fallaba, aquí añadiremos soporte para `tmpfs`. Systemd requiere escribir en `/run` y `/tmp` durante el arranque; si estos no están montados como sistemas de archivos temporales en memoria, el contenedor entrará en un bucle de reinicios y fallará.

> Crea el archivo `docker-compose.yml` con este contenido corregido:

```yaml
services:
  freeipa:
    image: freeipa/freeipa-server:rocky-9
    container_name: freeipa-server
    hostname: ipa.test.local
    domainname: test.local
    environment:
      - PASSWORD=admin123
      - IPA_SERVER_INSTALL_OPTS=-U -r TEST.LOCAL --no-ntp
    privileged: true
    # CORRECCIÓN CRÍTICA: Systemd necesita tmpfs para arrancar correctamente
    tmpfs:
      - /run
      - /tmp
    volumes:
      - freeipa-data:/data
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    ports:
      - "80:80"
      - "443:443"
      - "389:389"
      - "636:636"
      - "88:88/udp"
      - "88:88"
      - "464:464/udp"
      - "464:464"
    command: /usr/sbin/init
    restart: unless-stopped

volumes:
  freeipa-data:

```

### 1.3 Resolución de nombres local

FreeIPA depende estrictamente de que el nombre de dominio coincida con la IP. Como no tenemos un servidor DNS real configurado en nuestra red de laboratorio, debemos "engañar" a nuestro ordenador local. Editando el archivo `hosts`, forzamos a que nuestro sistema sepa que `ipa.test.local` es, en realidad, nuestra propia máquina (`127.0.0.1`).

> Agrega esta línea a tu archivo `/etc/hosts` (Linux/Mac) o `C:\Windows\System32\drivers\etc\hosts` (Windows):
> ```text
> 127.0.0.1 ipa.test.local
> 
> ```
> 
> 

### 1.4 Despliegue e inicialización

Ahora levantaremos la infraestructura. Al usar la opción `-d` (detached), el proceso corre en segundo plano. La instalación de FreeIPA no es instantánea; el contenedor debe configurar internamente las instancias de LDAP y Kerberos. Observar los logs nos permite entender qué ocurre "bajo el capó" y confirmar el momento exacto en que el servicio está listo.

> Inicia el contenedor y vigila la instalación:
> ```bash
> docker-compose up -d
> docker logs -f freeipa-server
> 
> ```
> 
> 
> *Espera hasta ver el mensaje "FreeIPA server configured".*

## Paso 2: Acceso a la Administración Web

**Introducción:**
Aunque los administradores avanzados suelen usar la línea de comandos (CLI), FreeIPA proporciona una potente interfaz web para la gestión diaria. En este paso verificaremos que los servicios web (Apache y Tomcat funcionando dentro del contenedor) están respondiendo. Notarás una advertencia de seguridad en el navegador: esto es normal y esperado. FreeIPA ha generado sus propios certificados de seguridad (SSL/TLS) "autofirmados" para encriptar el tráfico. Como tu navegador no conoce a la autoridad que firmó esos certificados (que es el propio servidor FreeIPA), te alerta por precaución.

### 2.1 Conexión segura (HTTPS)

Vamos a acceder al panel de control. Es vital usar el nombre de dominio `ipa.test.local` y no `localhost` o la dirección IP, ya que la configuración de seguridad de Kerberos podría rechazar la conexión si el nombre del host no coincide exactamente con el certificado del servidor.

> Abre tu navegador, entra a `https://ipa.test.local` y acepta la advertencia de seguridad (Configuración avanzada -> Proceder/Acceder).

### 2.2 Autenticación administrativa

Para entrar, usaremos la cuenta raíz del sistema FreeIPA. El usuario `admin` tiene control total sobre el dominio: puede crear usuarios, definir políticas de contraseñas, gestionar reglas de acceso (HBAC) y configurar la replicación. Es el equivalente al "Domain Admin" en Windows.

> Inicia sesión con:
> * **Usuario:** `admin`
> * **Contraseña:** `admin123`
> 
> 

## Paso 3: Gestión de Identidades (Crear Usuario)

**Introducción:**
Un directorio vacío no tiene utilidad. Ahora actuaremos como administradores creando una identidad digital para un empleado ficticio. En FreeIPA, un "usuario" es más que un nombre y una contraseña; es un objeto LDAP que contiene atributos (nombre, apellido, shell, carpeta home, grupos). Al crear este usuario, el sistema también genera automáticamente las claves Kerberos necesarias para que este usuario pueda autenticarse de forma segura en cualquier servicio unido al dominio sin enviar su contraseña en texto plano por la red.

### 3.1 Navegación al área de usuarios

La interfaz de FreeIPA organiza los recursos en pestañas lógicas. La sección "Identity" es el corazón del sistema, donde se gestionan no solo personas, sino también grupos de usuarios, hosts (máquinas) y grupos de hosts. Vamos a dar de alta una nueva entrada en el directorio.

> En la interfaz web, ve a la pestaña **Identity**, luego al submenú **Users** y haz clic en el botón **Add** (arriba a la derecha).

### 3.2 Definición de atributos del usuario

Vamos a rellenar los datos obligatorios. Observa cómo el sistema sugiere automáticamente el "User login" (nombre de usuario) basándose en los nombres reales. Definiremos una contraseña inicial. En un entorno real, marcaríamos la opción para forzar el cambio de contraseña en el primer inicio de sesión por seguridad.

> Rellena los datos y pulsa **Add**:
> * **User login:** `usuario1`
> * **First name:** `Juan`
> * **Last name:** `Pérez`
> * **Password:** `juan1234`
> 
> 

## Paso 4: Validación Técnica vía LDAP

**Introducción:**
¿Cómo sabemos que el usuario realmente existe y es accesible para otros sistemas? Vamos a realizar una prueba técnica simulando ser un cliente externo. Utilizaremos el protocolo **LDAP** (Lightweight Directory Access Protocol), que es el lenguaje estándar que usan las aplicaciones para "preguntar" al directorio. Para hacer la prueba realista, lanzaremos un segundo contenedor Docker (un cliente Debian limpio) que no tiene nada instalado, y desde allí intentaremos "llamar" al servidor FreeIPA para verificar las credenciales de Juan Pérez.

### 4.1 Preparación del cliente de prueba

Usaremos un comando de Docker avanzado. Conectaremos un contenedor temporal directamente a la red del servidor (`--network container:...`). Esto simula que ambos están en el mismo cable de red. Instalaremos las `ldap-utils`, que son herramientas de diagnóstico estándar en Linux para hacer consultas a directorios.

> Ejecuta este bloque de comando en tu terminal:

```bash
docker run --rm --network container:freeipa-server debian:latest bash -c "\
apt update && apt install -y ldap-utils && \
ldapwhoami -x -D 'uid=usuario1,cn=users,cn=accounts,dc=test,dc=local' \
-w juan1234 -H ldap://localhost -o TLS_REQ_CERT=never"

```

### 4.2 Interpretación de resultados

Analicemos el comando anterior: `ldapwhoami` intenta autenticarse. Hemos añadido `-o TLS_REQ_CERT=never` para evitar errores con el certificado autofirmado y usamos `localhost` porque compartimos red con el servidor. Si el servidor responde con el DN (Distinguished Name), significa que la base de datos LDAP está operativa y la contraseña es correcta.

> Si ves el siguiente resultado, la prueba ha sido un éxito:
> ```text
> dn:uid=usuario1,cn=users,cn=accounts,dc=test,dc=local
> 
> ```
> 
> 

## Paso 5 (Avanzado): Integración de un Cliente Linux Real

**Introducción:**
Este paso final es la prueba de fuego: unir un sistema operativo completo al dominio. A diferencia de la prueba LDAP simple anterior, esto configura **PAM** y **NSS** en el cliente. Esto significa que el sistema operativo delegará la autenticación al servidor FreeIPA. Si funciona, podrás hacer `login` en tu máquina con el usuario `usuario1` como si fuera una cuenta local. **Nota:** Este paso es sensible a la configuración de red y puede requerir ajustes adicionales si estás usando máquinas virtuales o WSL.

### 5.1 Instalación del cliente

Necesitamos instalar el software cliente de FreeIPA en tu máquina (no en el servidor Docker, sino en otra máquina Linux que actúe como cliente, o en otra VM). Este software incluye los módulos necesarios para que Linux entienda usuarios de red y tickets de Kerberos.

> En tu máquina cliente (ej. Ubuntu/Debian), instala:
> ```bash
> sudo apt update && sudo apt install freeipa-client
> 
> ```
> 
> 

### 5.2 Unión al dominio (Enrollment)

Ejecutaremos el script de unión. Este script configura automáticamente el `/etc/krb5.conf` y `/etc/sssd/sssd.conf`. Es importante usar `--mkhomedir` para que se cree la carpeta personal del usuario al iniciar sesión por primera vez, ya que no existe físicamente en el disco del cliente.

> **Importante:** Asegúrate de que el cliente pueda hacer ping a `ipa.test.local`. Luego ejecuta:
> ```bash
> sudo ipa-client-install --domain=test.local --server=ipa.test.local \
> --principal=admin --password=admin123 --mkhomedir --force-ntpd --no-dns-sshfp
> 
> ```
> 
> 

### 5.3 Verificación final

Si la instalación termina sin errores, el sistema ya es parte del dominio. Ya no necesitas crear cuentas locales con `useradd`. Simplemente intenta cambiar de usuario en la terminal. Si el prompt cambia, el sistema ha validado la identidad contra el servidor Dockerizado correctamente.

> Prueba el acceso:
> ```bash
> su - usuario1
> # Introduce la contraseña juan1234
> whoami
> 
> ```
> 
>
