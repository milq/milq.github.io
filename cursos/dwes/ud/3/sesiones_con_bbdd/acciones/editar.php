<?php
$título_página = 'Editar';

require_once '../plantillas/cabecera.php';
require_once '../sesiones/comprobar_sesion.php';

if ($conectado && $es_admin) {
    require_once '../include/connect_db.php';

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        if (isset($_POST['id_mensaje'], $_POST['asunto'], $_POST['cuerpo'], $_POST['fecha'], $_POST['id_usuario'])) {
            $id_mensaje = filter_var($_POST['id_mensaje'], FILTER_VALIDATE_INT);
            $subject = trim($_POST['asunto']);
            $body = trim($_POST['cuerpo']);
            $date = $_POST['fecha'] ?? '';
            $is_valid_date = preg_match('/^\d{4}-\d{2}-\d{2}$/', $date);
            $user_id = filter_var($_POST['id_usuario'], FILTER_VALIDATE_INT);

            if ($id_mensaje && $subject && $body && $is_valid_date && $user_id) {
                $sql = 'UPDATE mensajes SET asunto = ?, cuerpo = ?, fecha = ?, id_usuario = ? WHERE id = ?';
                $sth = $dbh->prepare($sql);
                try {
                    $sth->execute([$subject, $body, $date, $user_id, $id_mensaje]);
                    if ($sth->rowCount() === 1) {
                        $message = 'El mensaje se ha editado con éxito.';
                    } else {
                        $message = 'No se realizaron cambios.';
                    }
                } catch (PDOException $e) {
                    $message = 'Error al editar el mensaje: ' . $e->getMessage();
                }
            } else {
                $message = 'Por favor, complete todos los campos según su tipo de dato y verifique el formato de fecha: YYYY-MM-DD.';
            }
        } elseif (isset($_POST['id_mensaje'])) {
            // Obtener el mensaje para editar
            $id_mensaje = filter_var($_POST['id_mensaje'], FILTER_VALIDATE_INT);

            $sql = 'SELECT * FROM mensajes WHERE id = ?';
            $sth = $dbh->prepare($sql);
            $sth->execute([$id_mensaje]);
            $mensaje = $sth->fetch(PDO::FETCH_ASSOC);

            if (!$mensaje) {
                $message = 'No existe un mensaje con ese identificador.';
            }
        }
    }
}
?>
<?php require_once '../plantillas/navegacion.php'; ?>

<h2>Editar</h2>

<?php if ($conectado && $es_admin) { ?>
    <?php if (isset($message)) { ?>
        <p><?= htmlspecialchars($message, ENT_QUOTES, 'UTF-8') ?></p>
    <?php } ?>

    <?php if (isset($mensaje)) { ?>
        <!-- Mostrar formulario para editar el mensaje -->
        <form action='editar.php' method='post'>
            <input type='hidden' name='id_mensaje' value='<?= htmlspecialchars($id_mensaje, ENT_QUOTES, 'UTF-8') ?>' />
            <label for='asunto'>Asunto:</label>
            <input type='text' name='asunto' id='asunto' value='<?= htmlspecialchars($mensaje['asunto'], ENT_QUOTES, 'UTF-8') ?>' required /><br />
            <label for='cuerpo'>Cuerpo:</label>
            <input type='text' name='cuerpo' id='cuerpo' value='<?= htmlspecialchars($mensaje['cuerpo'], ENT_QUOTES, 'UTF-8') ?>' required /><br />
            <label for='fecha'>Fecha:</label>
            <input type='text' name='fecha' id='fecha' value='<?= htmlspecialchars($mensaje['fecha'], ENT_QUOTES, 'UTF-8') ?>' required /><br />
            <label for='id_usuario'>ID del usuario-autor:</label>
            <input type='text' name='id_usuario' id='id_usuario' value='<?= htmlspecialchars($mensaje['id_usuario'], ENT_QUOTES, 'UTF-8') ?>' required /><br />
            <input type='submit' value='Actualizar' />
        </form>
    <?php } elseif (!isset($_POST['id_mensaje']) || isset($message)) { ?>
        <!-- Formulario para seleccionar el mensaje a editar -->
        <form action='editar.php' method='post'>
            <label for='id_mensaje'>ID del mensaje que quieres editar:</label>
            <input type='number' name='id_mensaje' id='id_mensaje' required /><br />
            <input type='submit' value='Enviar' />
        </form>
    <?php } ?>
<?php } else { ?>
    <p>No has iniciado sesión como administrador.</p>
<?php } ?>

<?php require_once '../plantillas/pie.php'; ?>
