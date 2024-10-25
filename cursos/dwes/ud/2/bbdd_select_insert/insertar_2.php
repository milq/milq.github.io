<?php
$mensaje = '';

require_once('connect_db.php');

if (isset($_POST['asunto']) && isset($_POST['cuerpo']) && !empty($_POST['fecha']) && !empty($_POST['id_usuario'])) {
    $subject = trim($_POST['asunto']);
    $body = trim($_POST['cuerpo']);
    $date_message = $_POST['fecha'];
    $user_id = filter_var($_POST['id_usuario'], FILTER_VALIDATE_INT);

    if (strlen($subject) > 100) {
        $mensaje = 'El asunto no debe tener más de 100 caracteres.';
    } elseif (strlen($body) > 1000) {
        $mensaje = 'El cuerpo no debe tener más de 1000 caracteres.';
    } elseif (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $date_message)) {
        $mensaje = 'La fecha debe estar en el formato YYYY-MM-DD.';
    } elseif ($user_id === false) {
        $mensaje = 'El ID de usuario no es válido.';
    } else {

        $sth = $dbh->prepare('INSERT INTO mensajes(asunto, cuerpo, fecha, id_usuario) VALUES (?, ?, ?, ?)');

        try {
            $sth->execute([$subject, $body, $date_message, $user_id]);
            $mensaje = 'El mensaje se ha insertado con éxito.';
        } catch (PDOException $e) {
            $error = $e->getMessage();
            $mensaje = 'La inserción ha fallado. Error: ' . $error;
        }
    }
} else {
    $mensaje = 'La fecha o el identificador del usuario está vacío.';
}
?>

<!DOCTYPE html>
<html xmlns='http://www.w3.org/1999/xhtml' lang='es'>
  <head>
    <meta charset='utf-8' />
    <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=2.0' />
    <link rel='stylesheet' type='text/css' href='estilo.css' />
    <title>Mensajes</title>
  </head>
  <body>
    <h1>Mensajes</h1>

    <nav>
      <a href='index.php'>Inicio</a> |
      <a href='ver.php'>Ver</a> |
      Añadir
    </nav>

    <h2>Insertar</h2>

    <p><?php echo htmlspecialchars($mensaje, ENT_QUOTES, 'UTF-8'); ?></p>

    <footer>
      <p>Ejemplo de clase creado por Manuel Ignacio López Quintero.</p>
    </footer>
  </body>
</html>
