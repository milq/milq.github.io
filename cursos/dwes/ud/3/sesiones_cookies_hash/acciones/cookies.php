<?php
$titulo_pagina = 'Cookies';

require_once '../plantillas/cabecera.php';
require_once '../sesiones/comprobar_sesion.php';
require_once '../plantillas/navegacion.php';

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

?>

<h2>Cookies</h2>

<p>Has visitado esta página <?= $contador ?> veces en la última hora.</p>

<p><a href="<?= $_SERVER['PHP_SELF'] ?>">Entrar de nuevo en esta página</a></p>

<p><a href='?accion=borrar'>Borrar contador de visitas</a></p>

<p><a href='?accion=modificar'>Modificar contador a 50 visitas</a></p>

<?php require_once '../plantillas/pie.php'; ?>
