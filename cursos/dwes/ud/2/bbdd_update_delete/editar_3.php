<?php
require_once('connect_db.php');
$mensaje = '';

if (!empty($_POST['id_mensaje']) && isset($_POST['asunto'], $_POST['cuerpo'], $_POST['fecha'], $_POST['id_usuario'])) {
    $id_mensaje = filter_var($_POST['id_mensaje'], FILTER_VALIDATE_INT);
    $subject = trim($_POST['asunto']);
    $body = trim($_POST['cuerpo']);
    $date_message = $_POST['fecha'];
    $user_id = filter_var($_POST['id_usuario'], FILTER_VALIDATE_INT);

    if ($id_mensaje === false) {
        $mensaje = 'El identificador del mensaje no es válido.';
    } elseif ($user_id === false) {
        $mensaje = 'El identificador del usuario no es válido.';
    } elseif (strlen($subject) > 100) {
        $mensaje = 'El asunto no debe tener más de 100 caracteres.';
    } elseif (strlen($body) > 1000) {
        $mensaje = 'El cuerpo no debe tener más de 1000 caracteres.';
    } elseif (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $date_message)) {
        $mensaje = 'La fecha debe estar en el formato YYYY-MM-DD.';
    } else {
        $sql = 'UPDATE mensajes SET asunto = ?, cuerpo = ?, fecha = ?, id_usuario = ? WHERE id = ?';
        $sth = $dbh->prepare($sql);

        try {
            $sth->execute([$subject, $body, $date_message, $user_id, $id_mensaje]);
            $mensaje = $sth->rowCount() === 1 ? 'El mensaje se ha editado con éxito.' : 'No existe un mensaje con ese identificador.';
        } catch (PDOException $e) {
            $mensaje = 'La edición ha fallado. Error: ' . htmlspecialchars($e->getMessage(), ENT_QUOTES, 'UTF-8');
        }
    }
} else {
    $mensaje = 'El identificador del mensaje, la fecha o el identificador del usuario está vacío.';
}
?>

<!DOCTYPE html>
<html lang='es'>

  <head>
    <meta charset='utf-8' />
    <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=2.0' />
    <link rel='stylesheet' href='estilo.css' />
    <title>Mensajes</title>
  </head>

  <body>

    <h1>Mensajes</h1>

    <nav>
      <a href='index.php'>Inicio</a> |
      <a href='ver.php'>Ver</a> |
      <a href='insertar_1.php'>Añadir</a> |
      Editar |
      <a href='borrar_1.php'>Borrar</a>
    </nav>

    <h2>Editar</h2>

    <p><?php echo htmlspecialchars($mensaje, ENT_QUOTES, 'UTF-8'); ?></p>

    <footer>
      <p>Ejemplo de clase creado por Manuel Ignacio López Quintero.</p>
    </footer>
  </body>
</html>
