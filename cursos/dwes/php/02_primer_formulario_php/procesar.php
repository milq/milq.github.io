<?php

// El array $_POST recoge los datos enviados por el formulario utilizando el método POST.
// Cada elemento del array $_POST corresponde a un campo del formulario, 
// y la clave de cada elemento es el valor del atributo 'name' del input correspondiente.
// Por ejemplo, $_POST['age'] obtiene el valor ingresado en el campo de texto cuyo
// atributo 'name' es 'age' en el formulario.

$name = $_POST['name'];
$age = $_POST['age'];
$education = $_POST['education'];

if (isset($_POST['hobbies']) && !empty($_POST['hobbies'])) {
    $aficiones = implode(', ', $_POST['hobbies']);
} else {
    $aficiones = 'ninguna afición seleccionada';
}

?>

<!DOCTYPE html>
<html xmlns='http://www.w3.org/1999/xhtml' lang='es'>
  <head>
    <meta charset='utf-8' />
    <meta name='viewport' content='width=device-width, initial-scale=1.0' />
    <title>Formulario básico</title>
  </head>

  <body>
    <h1>Formulario básico</h1>

    <p>Datos recogidos:</p>

    <ul>
      <li><strong>Nombre:</strong> <?php echo $name; ?></li>
      <li><strong>Edad:</strong> <?php echo $age; ?></li>
      <li><strong>Nivel de estudios:</strong> <?php echo $education; ?></li>
      <li><strong>Aficiones:</strong> <?php echo $aficiones; ?></li>
    </ul>

  </body>
</html>
