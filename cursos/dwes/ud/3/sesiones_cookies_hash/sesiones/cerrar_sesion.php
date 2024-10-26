<?php

$titulo_pagina = 'Cerrar sesión';

require_once '../plantillas/cabecera.php';

session_start();

$_SESSION = [];

session_destroy();

require_once 'comprobar_sesion.php';

?>

<?php require_once '../plantillas/navegacion.php'; ?>

<h2>Cerrar sesión</h2>

<p>Has cerrado sesión, ¡hasta luego!</p>

<?php require_once '../plantillas/pie.php'; ?>
