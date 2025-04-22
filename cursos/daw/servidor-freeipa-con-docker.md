# Tutorial: Crea y configura un servidor FreeIPA en local y prueba la autenticación de un usuario

En este tutorial aprenderás a crear un servidor FreeIPA dentro de un contenedor Docker, configurarlo de forma automática y probar que un usuario puede autenticarse correctamente desde un cliente.

## Paso 1: Crear y ejecutar un servidor FreeIPA en Docker

1. Crea una carpeta para tu proyecto con `mkdir freeipa-lab` y accede a ella con `cd freeipa-lab`.

2. Crea un archivo llamado `docker-compose.yml` con este contenido:

   ```yaml
   version: '3'

   services:
     freeipa:
       image: freeipa/freeipa-server:rocky-9
       container_name: freeipa-server
       hostname: ipa.test.local
       environment:
         - IPA_SERVER_INSTALL_OPTS=--unattended
         - PASSWORD=admin123
       tmpfs:
         - /run
         - /tmp
       ports:
         - "80:80"
         - "443:443"
         - "389:389"
         - "636:636"
         - "88:88"
         - "464:464"
       volumes:
         - freeipa-data:/data:Z
       sysctls:
         net.ipv6.conf.all.disable_ipv6: 0

   volumes:
     freeipa-data:
   ```

   Este archivo `docker-compose.yml` define un contenedor que ejecuta un servidor FreeIPA usando la imagen oficial basada en Rocky Linux. Le asigna el nombre `ipa.test.local`, que será su dominio de red interno. Se configura automáticamente con la opción `--unattended`, lo que significa que se instalará sin pedir datos manualmente, usando la contraseña `admin123` para el administrador. Se utilizan volúmenes temporales (`/run` y `/tmp`) requeridos por FreeIPA, y un volumen persistente llamado `freeipa-data` para guardar toda la configuración del servidor, usuarios, y base de datos LDAP. Además, se exponen todos los puertos necesarios: HTTP (80, 443), LDAP (389, 636), y Kerberos (88, 464). Finalmente, se asegura de que IPv6 esté habilitado para compatibilidad total con las herramientas del sistema FreeIPA.

3. Agrega el nombre del _host_ al archivo `/etc/hosts` (Linux/WSL) o `C:\Windows\System32\drivers\etc\hosts` (Windows):

   ```
   127.0.0.1 ipa.test.local
   ```

4. Inicia el contenedor:

   ```bash
   docker-compose up -d
   ```

   Espera entre 1 y 2 minutos mientras se instala FreeIPA. Puedes ver el progreso con:

   ```bash
   docker logs -f freeipa-server
   ```

## Paso 2: Acceder a la interfaz web de FreeIPA

1. Abre tu navegador y entra a:

   ```
   https://ipa.test.local
   ```

2. Acepta el certificado autofirmado.

3. Inicia sesión con:

   - Usuario: `admin`
   - Contraseña: `admin123`

Ahora tienes un servidor FreeIPA totalmente funcional.

## Paso 3: Crear un usuario de prueba

1. Desde la interfaz web, ve a **Identity > Users > Add**.

2. Crea un usuario como este:

   - **Username:** `usuario1`
   - **First name:** `Juan`
   - **Last name:** `Pérez`
   - **Password:** asigna una contraseña simple como `juan1234`, y marca que debe cambiarla al iniciar sesión (o no, si es demo).

3. Guarda los cambios.

## Paso 4: Probar autenticación de un usuario con Docker (`ldapwhoami`)

Vamos a comprobar que el usuario creado (`usuario1`) puede autenticarse correctamente usando LDAP. Ejecutaremos el comando desde un contenedor auxiliar basado en Debian.

1. Ejecuta el siguiente contenedor temporal:

```bash
docker run --rm --network container:freeipa-server debian:latest bash -c "\
apt update && apt install -y ldap-utils && \
ldapwhoami -x -D 'uid=usuario1,cn=users,cn=accounts,dc=test,dc=local' -w juan1234 -H ldap://ipa.test.local"
```

Este comando:

    - Usa la imagen oficial de **Debian `latest`**.
    - Instala las herramientas necesarias (`ldap-utils`) dentro del contenedor.
    - Se conecta directamente al contenedor del servidor FreeIPA (`--network container:freeipa-server`).
    - Autentica al usuario `usuario1` con la contraseña `juan1234`.

2. Si la autenticación es exitosa, verás algo como:

```
dn:uid=usuario1,cn=users,cn=accounts,dc=test,dc=local
```

Esto confirma que el usuario fue creado correctamente y puede autenticarse contra el servidor FreeIPA.

## Paso 5 (opcional): Autenticación real de login en GNU/Linux

Hasta ahora hemos probado la autenticación a nivel de servicios (como LDAP), pero en este paso llevamos la integración un paso más allá: conectaremos un sistema GNU/Linux completo al dominio FreeIPA. Esto permite que los usuarios creados en FreeIPA puedan iniciar sesión en el sistema operativo como si fueran cuentas locales. Se integran mecanismos como Kerberos, PAM y NSS, lo que se traduce en una experiencia de login real, creación automática de carpetas personales (`/home`), y uso de identidades centralizadas, tal como lo haría una empresa con un dominio corporativo.

1. En un cliente GNU/Linux (no el servidor), instala:

   ```bash
   sudo apt install freeipa-client
   ```

2. Ejecuta el instalador:

   ```bash
   sudo ipa-client-install --domain=test.local --server=ipa.test.local \
                           --principal=admin --password=admin123 --mkhomedir --force-ntpd
   ```

3. Si todo va bien, podrás cerrar sesión e iniciar como `usuario1`.
