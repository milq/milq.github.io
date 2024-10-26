<?php
$titulo_pagina = 'Sesiones';

require_once '../plantillas/cabecera.php';
require_once '../sesiones/comprobar_sesion.php';
require_once '../plantillas/navegacion.php';

?>

<h2>Sesiones</h2>

<?php if ($conectado) { ?>
    <p>Has iniciado sesión correctamente como <em><?= $usuario; ?></em>.</p>
<?php } else { ?>
    <p>No has iniciado sesión.</p>
<?php } ?>

<?php require_once '../plantillas/pie.php'; ?>
