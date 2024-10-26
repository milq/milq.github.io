# Sistema de mensajes en PHP con sesiones y base de datos

Este proyecto es una aplicación web en PHP que permite gestionar mensajes con las funcionalidades CRUD (Crear, Leer, Actualizar y Eliminar). Incluye manejo de sesiones para verificar si el usuario está autenticado, y una conexión a una base de datos utilizando PDO. Esta guía didáctica te ayudará a comprender cómo conectar PHP con MySQL, manejar sesiones y estructurar un proyecto web.

## Instalación

1. Descarga esta [carpeta][DIR] en formato ZIP y descomprímela para obtener todo el código necesario.
2. Inicia XAMPP, crea una carpeta en `htdocs` y copia dentro de dicha carpeta el código proporcionado.
3. Accede a `http://localhost/nombre_carpeta` para probar el ejemplo y experimenta con el código.

[DIR]: https://download-directory.github.io/?url=https://github.com/milq/milq.github.io/tree/master/cursos/dwes/ud/3/sesiones_con_bbdd&filename=sesiones_con_bbdd

## Estructura del proyecto

El proyecto está organizado en varias carpetas y archivos para facilitar su mantenimiento.

### Carpetas y archivos principales

- `acciones/`
  - `ver.php`: Muestra los mensajes guardados en la base de datos.
  - `insertar.php`: Permite añadir un nuevo mensaje.
  - `editar.php`: Permite editar un mensaje existente.
  - `borrar.php`: Permite eliminar un mensaje.
- `include/`
  - `connect_db.php`: Define las credenciales y establece una conexión a MariaDB usando PDO.
- `plantillas/`
  - `cabecera.php`: Encabezado de la página. Incluye el título y el CSS.
  - `navegacion.php`: Barra de navegación principal.
  - `pie.php`: Pie de página.
- `sesiones/`
  - `iniciar_sesion.php`: Formulario y lógica para el inicio de sesión.
  - `cerrar_sesion.php`: Código para cerrar la sesión del usuario.
  - `comprobar_sesion.php`: Verifica si el usuario está autenticado y con qué rol.
- `estilo.css`: Archivo CSS para los estilos de la página web.
- `index.php`: Página principal de bienvenida. Explica brevemente la funcionalidad del sitio.
- `modelo.sql`: Contiene el _script_ para crear el modelo de base datos con inserciones de ejemplo.

## Sesiones en PHP

Las sesiones permiten recordar al usuario durante la navegación. Este proyecto utiliza sesiones para:

- Verificar si el usuario está autenticado para poder acceder a ciertas páginas.
- Cerrar sesión cuando el usuario lo desee.

## Operaciones CRUD

### 1. Ver Mensajes
- **Archivo**: `acciones/ver.php`
- **Función**: Recupera los mensajes almacenados en la base de datos y los muestra en pantalla.

### 2. Insertar Mensaje
- **Archivo**: `acciones/insertar.php`
- **Función**: Proporciona un formulario para añadir un nuevo mensaje y lo guarda en la base de datos.

### 3. Editar Mensaje
- **Archivo**: `acciones/editar.php`
- **Función**: Recupera un mensaje por su ID, lo muestra en un formulario y actualiza los cambios.

### 4. Borrar Mensaje
- **Archivo**: `acciones/borrar.php`
- **Función**: Permite eliminar un mensaje por su ID.
