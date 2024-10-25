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

    <form action='insertar_2.php' method='post'>
      Asunto: <input type='text' name='asunto' /><br />
      Cuerpo: <input type='text' name='cuerpo' /><br />
      Fecha: <input type='date' name='fecha' /><br />
      ID del usuario: <input type='text' name='id_usuario' /><br />
      <input type='submit' value='Enviar' />
    </form>

    <footer><p>Ejemplo de clase creado por Manuel Ignacio López Quintero.</p></footer>

  </body>
</html>
