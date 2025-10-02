<?php
$username = $biography = $phone = $email = $website = '';
$errors = [];

if ($_SERVER['REQUEST_METHOD'] == 'POST')
{
    if (isset($_POST['email']) && !empty($_POST['email'])) {
        $email = filter_var($_POST['email'], FILTER_SANITIZE_EMAIL);
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $errors[] = 'El correo electrónico es inválido.';
        }
    } else {
        $errors[] = 'El correo electrónico es obligatorio.';
    }

    if (isset($_POST['username']) && !empty($_POST['username'])) {
        $username = $_POST['username'];
        if (!preg_match('/^[a-zA-Z][a-zA-Z0-9]{3,15}$/', $username)) {
            $errors[] = 'Usuario inválido: debe ser alfanumérico comenzando por una letra y tener entre 4 y 16 caracteres.';
        }
    } else {
        $errors[] = 'El nombre de usuario es obligatorio.';
    }

    if (isset($_POST['biography']) && !empty($_POST['biography'])) {
        $biography = $_POST['biography'];
        if (mb_strlen($biography) > 100) {
            $errors[] = 'Biografía demasiado larga: máximo 100 caracteres permitidos.';
        }
    }

    if (isset($_POST['phone']) && !empty($_POST['phone'])) {
        $phone = $_POST['phone'];
        if (!preg_match('/^\+?[0-9]{9,15}$/', $phone)) {
            $errors[] = 'Teléfono inválido: debe contener entre 9 y 15 dígitos y puede comenzar opcionalmente con un "+".';
        }
    }

    if (isset($_POST['website']) && !empty($_POST['website'])) {
        $website = filter_var($_POST['website'], FILTER_VALIDATE_URL);
        if (!$website) {
            $errors[] = 'La URL del sitio web es inválida.';
        }
    }
}
?>

<!DOCTYPE html>
<html xmlns='http://www.w3.org/1999/xhtml' lang='es'>
  <head>
    <meta charset='utf-8' />
    <title>Formulario validado</title>
  </head>
  <body>
    <h1>Formulario validado</h1>

    <?php if (!empty($errors)) { ?>

    <p>El formulario no está validado por los siguientes errores:</p>

    <ul>

    <?php foreach ($errors as $error) { ?>
      <li><?php echo htmlspecialchars($error) ?></li>
    <?php } ?>

    </ul>

    <?php } else { ?>

    <p>Correo electrónico: <?php echo htmlspecialchars($email); ?></p>
    <p>Usuario: <?php echo htmlspecialchars($username); ?></p>
    <p>Biografía: <?php echo htmlspecialchars($biography); ?></p>
    <p>Teléfono: <?php echo htmlspecialchars($phone); ?></p>
    <p>Sitio web: <?php echo htmlspecialchars($website); ?></p>

    <?php } ?>
  </body>
</html>
