<?php
$título_página = 'Añadir';

require_once '../plantillas/cabecera.php';
require_once '../sesiones/comprobar_sesion.php';

if ($conectado && $es_admin && $_SERVER['REQUEST_METHOD'] === 'POST') {
    require_once '../include/connect_db.php';

    $subject = trim($_POST['asunto'] ?? '');
    $body = trim($_POST['cuerpo'] ?? '');
    $date = $_POST['fecha'] ?? '';
    $is_valid_date = preg_match('/^\d{4}-\d{2}-\d{2}$/', $date);
    $user_id = filter_var($_POST['id_usuario'] ?? '', FILTER_VALIDATE_INT);


    if ($subject && $body && $is_valid_date && $user_id) {
        $sth = $dbh->prepare('INSERT INTO mensajes (asunto, cuerpo, fecha, id_usuario) VALUES (?, ?, ?, ?)');
        try {
            $sth->execute([$subject, $body, $date, $user_id]);
            $message = 'El mensaje se ha insertado con éxito.';
        } catch (PDOException $e) {
            $message = 'Error al insertar el mensaje: ' . $e->getMessage();
        }
    } else {
        $message = 'Por favor, complete todos los campos según su tipo de dato y verifique el formato de fecha: YYYY-MM-DD.';
    }
}
?>
<?php require_once '../plantillas/navegacion.php'; ?>

<h2>Insertar</h2>

<?php if ($conectado && $es_admin) { ?>
    <form action='insertar.php' method='post'>
        <label for='asunto'>Asunto:</label>
        <input type='text' name='asunto' id='asunto' /><br />
        <label for='cuerpo'>Cuerpo:</label>
        <input type='text' name='cuerpo' id='cuerpo' /><br />
        <label for='fecha'>Fecha:</label>
        <input type='text' name='fecha' id='fecha' /><br />
        <label for='id_usuario'>ID del usuario-autor:</label>
        <input type='text' name='id_usuario' id='id_usuario' /><br />
        <input type='submit' value='Enviar' />
    </form>
    <?php if (isset($message)) { ?>
        <p><?= htmlspecialchars($message, ENT_QUOTES, 'UTF-8') ?></p>
    <?php } ?>
<?php } else { ?>
    <p>No has iniciado sesión como administrador.</p>
<?php } ?>

<?php require_once '../plantillas/pie.php'; ?>
