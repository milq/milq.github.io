<?php
require_once('connect_db.php');
$mensaje = '';

if (!empty($_POST['id_mensaje'])) {
    $id_message = filter_var($_POST['id_mensaje'], FILTER_VALIDATE_INT);

    if ($id_message === false) {
        $mensaje = 'El identificador del mensaje no es válido.';
    } else {
        $sql = 'DELETE FROM mensajes WHERE id = ?';
        $sth = $dbh->prepare($sql);
        $sth->execute([$id_message]);

        $mensaje = $sth->rowCount() === 1 ? 'El mensaje se ha borrado con éxito.' : 'No existe un mensaje con ese identificador.';
    }
} else {
    $mensaje = 'El identificador del mensaje está vacío.';
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
      <a href='editar_1.php'>Editar</a> |
      Borrar
    </nav>

    <h2>Borrar</h2>

    <p><?php echo htmlspecialchars($mensaje, ENT_QUOTES, 'UTF-8'); ?></p>

    <footer>
      <p>Ejemplo de clase creado por Manuel Ignacio López Quintero.</p>
    </footer>

  </body>
</html>
