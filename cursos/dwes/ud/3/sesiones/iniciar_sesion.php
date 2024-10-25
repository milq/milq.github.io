<?php

session_start();

$_SESSION['usuario'] = 'ricardo';
$_SESSION['rol'] = 'user';

$usuario = htmlspecialchars($_SESSION['usuario'], ENT_QUOTES, 'UTF-8');
$rol = htmlspecialchars($_SESSION['rol'], ENT_QUOTES, 'UTF-8');

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
        Iniciar sesión |
        <a href='cerrar_sesion.php'>Cerrar sesión</a>
    </nav>

    <h2>Iniciar sesión</h2>

    <p>Has iniciado sesión como <strong><?= $usuario ?></strong> con rol <strong><?= $rol ?></strong>.</p>

    <footer>
        <p>Ejemplo de clase creado por Manuel Ignacio López Quintero.</p>
    </footer>

</body>
</html>
