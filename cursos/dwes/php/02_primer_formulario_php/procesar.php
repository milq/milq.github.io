<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {  // Verifica que el formulario fue enviado usando el método POST
    // $_POST['name'] toma el valor del campo 'name' enviado desde el formulario.
    $name = $_POST['name'] ?? '';  // El operador ?? devuelve una cadena vacía si 'name' no está presente en $_POST.
    $age = $_POST['age'] ?? '';
    $education = $_POST['education'] ?? '';
    $hobbies = $_POST['hobbies'] ?? [];  // El operador ?? devuelve un array vacío si 'hobbies' no está presente en $_POST.

    // Verifica si hay aficiones seleccionadas
    $aficiones = !empty($hobbies) ? implode(', ', $hobbies) : 'ninguna afición seleccionada';
}

// Nota: La validación y saneamiento de los datos es necesario para garantizar la seguridad, pero se explicará más adelante.
// Por ejemplo, 'htmlspecialchars' evita problemas de seguridad como XSS.
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
      <li><strong>Nombre:</strong> <?php echo htmlspecialchars($name); ?></li>
      <li><strong>Edad:</strong> <?php echo htmlspecialchars($age); ?></li>
      <li><strong>Nivel de estudios:</strong> <?php echo htmlspecialchars($education); ?></li>
      <li><strong>Aficiones:</strong> <?php echo htmlspecialchars($aficiones); ?></li>
    </ul>

  </body>
</html>
