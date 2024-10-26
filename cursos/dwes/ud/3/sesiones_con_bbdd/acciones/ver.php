<?php
$título_página = 'Ver';

require_once '../plantillas/cabecera.php';
require_once '../sesiones/comprobar_sesion.php';

if ($conectado) {
    require_once '../include/connect_db.php';

    $sql = 'SELECT * FROM mensajes';
    $sth = $dbh->prepare($sql);
    $sth->execute();
    $mensajes = $sth->fetchAll(PDO::FETCH_ASSOC);
}

?>

<?php require_once '../plantillas/navegacion.php'; ?>

<h2>Ver</h2>

<?php if ($conectado): ?>
    <?php foreach ($mensajes as $mensaje): ?>
        <p>
            El mensaje con ID <?= htmlspecialchars($mensaje['id'], ENT_QUOTES, 'UTF-8') ?>
            tiene como asunto <em><?= htmlspecialchars($mensaje['asunto'], ENT_QUOTES, 'UTF-8') ?></em>
            y como cuerpo <em><?= htmlspecialchars($mensaje['cuerpo'], ENT_QUOTES, 'UTF-8') ?></em>
            con fecha <em><?= htmlspecialchars($mensaje['fecha'], ENT_QUOTES, 'UTF-8') ?></em>.
        </p>
    <?php endforeach; ?>
<?php else: ?>
    <p>No has iniciado sesión.</p>
<?php endif; ?>

<?php require_once '../plantillas/pie.php'; ?>
