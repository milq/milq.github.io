<?php
require_once('connect_db.php');
$error = '';

if (!empty($_POST['id_mensaje'])) {
    $id_message = filter_var($_POST['id_mensaje'], FILTER_VALIDATE_INT);

    if ($id_message === false) {
        $error = 'El identificador del mensaje no es válido.';
    } else {
        $sql = 'SELECT * FROM mensajes WHERE id = ?';
        $sth = $dbh->prepare($sql);
        $sth->execute([$id_message]);
        $resultado = $sth->fetch(PDO::FETCH_ASSOC);

        if ($resultado !== false) {
            $a = htmlspecialchars($resultado['asunto'], ENT_QUOTES, 'UTF-8');
            $c = htmlspecialchars($resultado['cuerpo'], ENT_QUOTES, 'UTF-8');
            $f = htmlspecialchars($resultado['fecha'], ENT_QUOTES, 'UTF-8');
            $i = htmlspecialchars($resultado['id_usuario'], ENT_QUOTES, 'UTF-8');
        } else {
            $error = 'No existe un mensaje con ese identificador.';
        }
    }
} else {
    $error = 'El identificador del mensaje está vacío.';
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

    <?php if (empty($error)) { ?>

      <form action='editar_3.php' method='post'>
        <input type='hidden' name='id_mensaje' value='<?= $id_message ?>' />
        Asunto: <input type='text' name='asunto' value='<?= $a ?>' /><br />
        Cuerpo: <input type='text' name='cuerpo' value='<?= $c ?>' /><br />
        Fecha: <input type='date' name='fecha' value='<?= $f ?>' /><br />
        ID del usuario: <input type='text' name='id_usuario' value='<?= $i ?>' /><br />
        <input type='submit' value='Enviar' />
      </form>

    <?php } else { ?>

      <p><?php echo htmlspecialchars($mensaje, ENT_QUOTES, 'UTF-8'); ?></p>

    <?php } ?>

    <footer>
      <p>Ejemplo de clase creado por Manuel Ignacio López Quintero.</p>
    </footer>
  </body>
</html>
