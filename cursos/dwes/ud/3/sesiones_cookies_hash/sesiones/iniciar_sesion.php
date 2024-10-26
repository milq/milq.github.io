<?php
$titulo_pagina = 'Iniciar sesión';

require_once '../plantillas/cabecera.php';
require_once 'comprobar_sesion.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    require_once '../include/connect_db.php';

    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';

    if ($email && $password) {
        $stmt = $dbh->prepare('SELECT username, password FROM usuarios WHERE email = ?');
        $stmt->execute([$email]);
        $resultado = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($resultado && password_verify($password, $resultado['password'])) {
            $_SESSION['usuario'] = $resultado['username'];
            $usuario = $_SESSION['usuario'];
            $conectado = true;
            $mensaje = 'Has iniciado sesión correctamente.';
        } else {
            $error = 'Correo electrónico o contraseña incorrectos.';
        }
    } else {
        $error = 'Por favor, completa todos los campos.';
    }
}

require_once '../plantillas/navegacion.php';

?>

<h2>Iniciar sesión</h2>

<?php if (isset($error)) { ?>
    <p style='color: red;'><?= htmlspecialchars($error) ?></p>
<?php } ?>

<?php if (isset($mensaje)) { ?>
    <p style='color: green;'><?= htmlspecialchars($mensaje) ?></p>
<?php } ?>

<?php if (!$conectado) { ?>
    <form action='iniciar_sesion.php' method='post'>
        <label for='email'>Correo electrónico:</label>
        <input type='text' name='email'><br />
        <label for='password'>Contraseña:</label>
        <input type='password' name='password'><br />
        <input type='submit' value='Iniciar sesión' />
    </form>
<?php } ?>

<?php require_once '../plantillas/pie.php'; ?>
