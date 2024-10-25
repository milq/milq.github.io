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
      <a href='insertar_1.php'>Añadir</a> |
      <a href='editar_1.php'>Editar</a> |
      Borrar
    </nav>

    <h2>Borrar</h2>

    <form action='borrar_2.php' method='post'>
      ID del mensaje que quieres borrar: <input type='text' name='id_mensaje' /><br />
      <input type='submit' value='Enviar' />
    </form>

    <footer><p>Ejemplo de clase creado por Manuel Ignacio López Quintero.</p></footer>

  </body>
</html>
