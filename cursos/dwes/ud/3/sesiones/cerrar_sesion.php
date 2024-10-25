<?php

session_start();

$_SESSION = array();

session_destroy();

?>

<!DOCTYPE html>
<html xmlns='http://www.w3.org/1999/xhtml' lang='es'>
  <head>
    <meta charset='utf-8' />
    <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=2.0' />
    <link rel='stylesheet' type='text/css' href='estilo.css' />
    <title>Sesiones</title>
  </head>

  <body>
    <h1>Sesiones</h1>

    <nav>
      <a href='index.php'>Inicio</a> |
      <a href='zona_usuario.php'>Zona de usuario</a> |
      <a href='zona_admin.php'>Zona de admin</a> |
      <a href='iniciar_sesion.php'>Iniciar sesión</a> |
      Cerrar sesión
    </nav>

    <h2>Cerrar sesión</h2>

    <p>Has cerrado sesión, ¡hasta luego!</p>

    <footer>
      <p>Ejemplo de clase creado por Manuel Ignacio López Quintero.</p>
    </footer>

  </body>
</html>
