<?php

session_start();

$usuario = $rol = null;

if (isset($_SESSION['usuario']) && isset($_SESSION['rol']))
{
    $usuario = htmlspecialchars($_SESSION['usuario'], ENT_QUOTES, 'UTF-8');
    $rol = htmlspecialchars($_SESSION['rol'], ENT_QUOTES, 'UTF-8');
}
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
      Zona de usuario |
      <a href='zona_admin.php'>Zona de admin</a> |
      <a href='iniciar_sesion.php'>Iniciar sesión</a> |
      <a href='cerrar_sesion.php'>Cerrar sesión</a>
    </nav>

    <h2>Zona de usuario</h2>

    <?php if ($usuario && $rol === 'user') { ?>

    <p>Hola, estás en la zona de usuario.</p>
    <p>Estas son las operaciones que puedes hacer: x, y, z.</p>

    <?php } elseif ($usuario && $rol === 'admin') { ?>

    <p>Hola, estás en la zona de usuario pero siendo administrador.</p>
    <p>Entra en la zona específica para el administrador.</p>

    <?php } else { ?>

    <p>Esta es una zona reservada para usuarios.</p>
    <p>Inicia sesión como usuario si quieres operar aquí.</p>

    <?php } ?>

    <footer>
      <p>Ejemplo de clase creado por Manuel Ignacio López Quintero.</p>
    </footer>
  </body>
</html>
