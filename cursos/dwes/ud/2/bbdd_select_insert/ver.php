<?php
require_once('connect_db.php');

try {
    $sql = 'SELECT * FROM mensajes';

    $sth = $dbh->prepare($sql);
    $sth->execute();

    $res = $sth->fetchAll();

    $num_filas = count($res);

} catch (PDOException $e) {
    $error = $e->getMessage();
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
      Ver |
      <a href='insertar_1.php'>Añadir</a>
    </nav>

    <h2>Ver</h2>

    <?php if (!isset($error)) { ?>

    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Asunto</th>
          <th>Cuerpo</th>
          <th>Fecha</th>
          <th>Usuario</th>
        </tr>
      </thead>
      <tbody>
        <?php for ($i = 0; $i < $num_filas; $i++) { ?>
          <tr>
            <td><?= htmlspecialchars($res[$i]['id']) ?></td>
            <td><?= htmlspecialchars($res[$i]['asunto']) ?></td>
            <td><?= htmlspecialchars($res[$i]['cuerpo']) ?></td>
            <td><?= htmlspecialchars($res[$i]['fecha']) ?></td>
            <td><?= htmlspecialchars($res[$i]['id_usuario']) ?></td>
          </tr>
        <?php } ?>
      </tbody>
    </table>

    <?php } else { ?>
      <p>Error: <?= htmlspecialchars($error); ?></p>
    <?php } ?>

    <footer>
      <p>Ejemplo de clase creado por Manuel Ignacio López Quintero.</p>
    </footer>
  </body>
</html>
