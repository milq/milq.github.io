<?php
$titulo_pagina = 'Registrarse';

require_once '../plantillas/cabecera.php';
require_once '../plantillas/navegacion.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    require_once '../include/connect_db.php';

    $email = trim($_POST['email'] ?? '');
    $username = trim($_POST['username'] ?? '');
    $password = $_POST['password'] ?? '';
    $password_confirm = $_POST['password_confirm'] ?? '';

    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error = 'Por favor, introduce un correo electrónico válido.';
    }
    elseif (!preg_match('/^[a-z][a-z0-9]{2,11}$/', $username)) {
        $error = 'El nombre de usuario debe tener entre 3 y 12 caracteres, comenzar con una letra minúscula y contener solo letras minúsculas o dígitos.';
    }
    elseif ($email && $username && $password && $password === $password_confirm) {
        $stmt = $dbh->prepare('SELECT id, email, username FROM usuarios WHERE email = ? OR username = ?');
        $stmt->execute([$email, $username]);
        $existingUser = $stmt->fetch();

        if ($existingUser) {
            if ($existingUser['email'] === $email) {
                $error = 'El correo electrónico ya está registrado.';
            } elseif ($existingUser['username'] === $username) {
                $error = 'El nombre de usuario ya está en uso.';
            }
        } else {
            $password_hash = password_hash($password, PASSWORD_DEFAULT);
            $stmt = $dbh->prepare('INSERT INTO usuarios (username, email, password) VALUES (?, ?, ?)');
            if ($stmt->execute([$username, $email, $password_hash])) {
                $mensaje = 'Registro exitoso. Ahora puedes iniciar sesión.';
            } else {
                $error = 'Error al registrar el usuario.';
            }
        }
    } else {
        $error = 'Por favor, haz que las contraseñas coincidan.';
    }
}
?>

<h2>Registrarse</h2>

<?php if (isset($error)): ?>
    <p style='color: red;'><?= htmlspecialchars($error) ?></p>
<?php endif; ?>

<?php if (isset($mensaje)) { ?>
    <p style='color: green;'><?= htmlspecialchars($mensaje) ?></p>
<?php } else { ?>
    <form action='registrar_usuario.php' method='post'>
        <label for='email'>Correo electrónico:</label>
        <input type='text' name='email'><br />
        <label for='username'>Nombre de usuario:</label>
        <input type='text' name='username'><br />
        <label for='password'>Contraseña:</label>
        <input type='password' name='password'><br />
        <label for='password_confirm'>Confirmar contraseña:</label>
        <input type='password' name='password_confirm'><br />
        <input type='submit' value='Registrarse' />
    </form>
<?php } ?>

<?php require_once '../plantillas/pie.php'; ?>
