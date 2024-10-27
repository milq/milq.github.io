# Ejemplo de sesiones, _hash_ y _cookies_ en PHP

Este proyecto es una aplicación web desarrollada en PHP que ilustra el uso de **sesiones**, **_cookies_** y **funciones de _hash_**. Está diseñado para ayudarte a comprender cómo gestionar la autenticación de usuarios, mantener sesiones y manipular _cookies_.

## Instalación, configuración y ejecución de este ejemplo

1. [Descarga la carpeta][DIR] del proyecto, descomprímela y cópiala en `htdocs` (o el directorio raíz de tu servidor web).
2. Inicia Apache y MariaDB desde XAMPP o tu servidor local preferido.
3. Usa PhpMyAdmin u otro administrador para ejecutar el archivo `modelo.sql` e inicializar la base de datos.
4. Comprueba las credenciales en `include/connect_db.php` según tu entorno.
5. Ve a `http://localhost/sesiones_cookies_hash` en tu navegador para comenzar.

[DIR]: https://download-directory.github.io/?url=https://github.com/milq/milq.github.io/tree/master/cursos/dwes/ud/3/sesiones_cookies_hash&filename=sesiones_cookies_hash

## Objetivos de este ejemplo

- **Entender las sesiones en PHP**: cómo iniciar, leer, modificar y destruir sesiones para manejar la autenticación de usuarios.
- **Utilizar funciones de _hash_**: cómo proteger contraseñas utilizando funciones de _hash_ seguras.
- **Manejar cookies**: cómo crear, leer, modificar y eliminar cookies para almacenar datos en el navegador del usuario.

## Conceptos clave

### Sesiones en PHP

Las sesiones permiten almacenar información en el servidor para ser utilizada en múltiples páginas. Esto es esencial para mantener el estado de autenticación del usuario mientras navega por el sitio.

- **Iniciar una sesión**: antes de trabajar con variables de sesión, debes llamar a `session_start();` al inicio del script.
  ```php
  session_start();
  ```
- **Almacenar datos en la sesión**: puedes guardar información en la variable superglobal `$_SESSION`.
  ```php
  $_SESSION['clave'] = 'valor';
  ```
- **Modificar datos de la sesión**: simplemente asigna un nuevo valor a la variable de sesión.
  ```php
  $_SESSION['clave'] = 'nuevo_valor';
  ```
- **Eliminar datos de la sesión**: puedes usar `unset()` para eliminar una variable de sesión específica.
  ```php
  unset($_SESSION['clave']);
  ```
- **Cerrar sesión**: para destruir toda la información de la sesión, utiliza `session_destroy();`.
  ```php
  session_destroy();
  ```

**Nota importante**: La función `session_start()` debe usarse siempre al principio si vamos a usar sesiones en la página PHP.

### Cookies en PHP

Las _cookies_ son pequeños archivos que se almacenan en el navegador del usuario y pueden ser utilizadas para almacenar información entre sesiones.

- **Crear una _cookie_**: usa `setcookie()` antes de enviar cualquier salida al navegador.
  ```php
  setcookie('nombre', 'valor', tiempo_de_expiración);
  ```
- **Leer una _cookie_**: Accede a la variable superglobal `$_COOKIE`.
  ```php
  $valor = $_COOKIE['nombre'];
  ```
- **Modificar una _cookie_**: vuelve a llamar a `setcookie()` con el mismo nombre y un nuevo valor.
  ```php
  setcookie('nombre', 'nuevo_valor', nuevo_tiempo_de_expiración);
  ```
- **Eliminar una _cookie_**: establece su tiempo de expiración en una fecha pasada.
  ```php
  setcookie('nombre', '', time() - 3600);
  ```

**Nota importante**: al igual que con las sesiones, las funciones relacionadas con _cookies_ deben ser llamadas **antes de enviar cualquier salida** al navegador.

### Hash de contraseñas

Para almacenar contraseñas de forma segura, es importante utilizar funciones _hash_ que transformen la contraseña en una cadena irreconocible.

- **Crear un _hash_**: utiliza `password_hash()` para generar un _hash_ seguro.
  ```php
  $hash = password_hash('contraseña', PASSWORD_DEFAULT);
  ```
- **Verificar una contraseña**: utiliza `password_verify()` para comparar una contraseña ingresada con su _hash_ almacenado.
  ```php
  if (password_verify('contraseña', $hash_almacenado)) {
      // La contraseña es correcta
  }
  ```

## Estructura del proyecto

El proyecto está organizado en varias carpetas y archivos para facilitar su comprensión y mantenimiento.

### Carpetas y archivos

- `acciones/`:
    - `sesiones.php`: Demostración del uso de sesiones en PHP.
    - `cookies.php`: Demostración del uso de cookies en PHP.

* `include/`:
    - `connect_db.php`: Establece la conexión a la base de datos utilizando PDO.

- `plantillas/`:
    - `cabecera.php`: Contiene el encabezado de la página, incluyendo la etiqueta `<head>` y la apertura del `<body>`.
    - `navegacion.php`: Barra de navegación que incluye enlaces a las diferentes secciones de la aplicación.
    - `pie.php`: Pie de página que cierra las etiquetas HTML abiertas.

* `sesiones/`:
    - `iniciar_sesion.php`: Formulario y lógica para el inicio de sesión de usuarios.
    - `registrar_usuario.php`: Formulario y lógica para el registro de nuevos usuarios.
    - `cerrar_sesion.php`: Lógica para cerrar la sesión del usuario.
    - `comprobar_sesion.php`: Verifica si el usuario está autenticado y establece variables de sesión.

- `index.php`: Página principal de bienvenida. Introduce la funcionalidad del sitio.
- `estilo.css`: Archivo CSS que contiene los estilos de la página web.
- `modelo.sql`: Script SQL para crear la base de datos y la tabla `usuarios`.

## Guía paso a paso

### 1. Registro de Usuarios

- Accede a `sesiones/registrar_usuario.php`.
- Completa el formulario con un correo electrónico, nombre de usuario y contraseña.
- La contraseña se le aplicará un _hash_ para almacenarla de forma segura en la base de datos.

**Ejemplo de código para registrar un usuario:**

```php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    require_once '../include/connect_db.php';

    $email = trim($_POST['email'] ?? '');
    $username = trim($_POST['username'] ?? '');
    $password = $_POST['password'] ?? '';
    $password_confirm = $_POST['password_confirm'] ?? '';

    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error = 'Por favor, introduce un correo electrónico válido.';
    }
    elseif (!preg_match('/^[a-z][a-z0-9]{2,11}$/', $username)) {
        $error = 'El nombre de usuario debe tener entre 3 y 12 caracteres, comenzar con una letra minúscula y contener solo letras minúsculas o dígitos.';
    }
    elseif ($email && $username && $password && $password === $password_confirm) {
        $stmt = $dbh->prepare('SELECT id, email, username FROM usuarios WHERE email = ? OR username = ?');
        $stmt->execute([$email, $username]);
        $existingUser = $stmt->fetch();

        if ($existingUser) {
            if ($existingUser['email'] === $email) {
                $error = 'El correo electrónico ya está registrado.';
            } elseif ($existingUser['username'] === $username) {
                $error = 'El nombre de usuario ya está en uso.';
            }
        } else {
            $password_hash = password_hash($password, PASSWORD_DEFAULT);
            $stmt = $dbh->prepare('INSERT INTO usuarios (username, email, password) VALUES (?, ?, ?)');
            if ($stmt->execute([$username, $email, $password_hash])) {
                $mensaje = 'Registro exitoso. Ahora puedes iniciar sesión.';
            } else {
                $error = 'Error al registrar el usuario.';
            }
        }
    } else {
        $error = 'Por favor, haz que las contraseñas coincidan.';
    }
}
```

### 2. Inicio de Sesión

- Accede a `sesiones/iniciar_sesion.php`.
- Introduce tus credenciales.
- Si son correctas, se iniciará una sesión y podrás acceder a contenido restringido.

**Ejemplo de código para iniciar sesión:**

```php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    require_once '../include/connect_db.php';

    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';

    if ($email && $password) {
        $stmt = $dbh->prepare('SELECT username, password FROM usuarios WHERE email = ?');
        $stmt->execute([$email]);
        $resultado = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($resultado && password_verify($password, $resultado['password'])) {
            session_start();
            $_SESSION['usuario'] = $resultado['username'];
            $usuario = $_SESSION['usuario'];
            $conectado = true;
            $mensaje = 'Has iniciado sesión correctamente.';
        } else {
            $error = 'Correo electrónico o contraseña incorrectos.';
        }
    } else {
        $error = 'Por favor, completa todos los campos.';
    }
}
```

**Nota**: observa que antes de manipular variables de sesión, llamamos a `session_start();`.

### 3. Uso de Sesiones

- Navega a `acciones/sesiones.php`.
- Verás información personalizada si has iniciado sesión.

### 4. Uso de _cookies_

- Navega a `acciones/cookies.php`.
- Se mostrará cuántas veces has visitado la página en la última hora.
- Puedes modificar o borrar el contador de visitas utilizando los enlaces proporcionados.

**Ejemplo de código para manejar _cookies_:**

```php
if (isset($_GET['accion'])) {
    if ($_GET['accion'] === 'borrar') {
        setcookie('contador', '', time() - 3600);
        $contador = 0;
    } elseif ($_GET['accion'] === 'modificar') {
        $contador = 50;
        setcookie('contador', $contador, time() + 3600);
    }
} else {
    if (isset($_COOKIE['contador'])) {
        $contador = $_COOKIE['contador'] + 1;
    } else {
        $contador = 1;
    }
    setcookie('contador', $contador, time() + 3600);
}
```

## Seguridad y buenas prácticas

- **Validación de datos**: siempre valida y sanea la entrada de los usuarios para prevenir ataques de inyección SQL y XSS.
- **Uso de _prepared statements_**: utiliza consultas preparadas con PDO para interactuar con la base de datos de forma segura.
- **Protección de contraseñas**: nunca almacenes contraseñas en texto plano. Utiliza funciones de _hash_ como `password_hash()`.

## Recursos Adicionales

- [Manual de PHP sobre sesiones](https://www.php.net/manual/es/book.session.php)
- [Manual de PHP sobre cookies](https://www.php.net/manual/es/function.setcookie.php)
- [Manual de PHP sobre funciones de hash](https://www.php.net/manual/es/book.password.php)
- [PDO en PHP](https://www.php.net/manual/es/book.pdo.php)
