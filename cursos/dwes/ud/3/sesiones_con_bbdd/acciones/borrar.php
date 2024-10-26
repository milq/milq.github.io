<?php
$título_página = 'Borrar';

require_once '../plantillas/cabecera.php';
require_once '../sesiones/comprobar_sesion.php';

if ($conectado && $es_admin && $_SERVER['REQUEST_METHOD'] === 'POST') {
    require_once '../include/connect_db.php';

    $id_mensaje = filter_var($_POST['id_mensaje'], FILTER_VALIDATE_INT);

    if ($id_mensaje) {
        $sql = 'DELETE FROM mensajes WHERE id = ?';
        $sth = $dbh->prepare($sql);
        $sth->execute([$id_mensaje]);

        if ($sth->rowCount() === 1) {
            $message = 'El mensaje se ha borrado con éxito.';
        } else {
            $message = 'No existe un mensaje con ese identificador.';
        }
    } else {
        $message = 'Por favor, proporciona un ID de mensaje válido.';
    }
}
?>

<?php require_once '../plantillas/navegacion.php'; ?>

<h2>Borrar</h2>

<?php if ($conectado && $es_admin) { ?>
    <?php if (isset($message)) { ?>
        <p><?= htmlspecialchars($message, ENT_QUOTES, 'UTF-8') ?></p>
    <?php } ?>

    <form action='borrar.php' method='post'>
        <label for='id_mensaje'>ID del mensaje que quieres borrar:</label>
        <input type='number' name='id_mensaje' id='id_mensaje' required /><br />
        <input type='submit' value='Borrar' />
    </form>
<?php } else { ?>
    <p>No has iniciado sesión como administrador.</p>
<?php } ?>

<?php require_once '../plantillas/pie.php'; ?>
