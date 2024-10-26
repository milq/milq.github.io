<?php

$título_página = 'Iniciar sesión';

require_once '../plantillas/cabecera.php';
require_once 'comprobar_sesion.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    require_once '../include/connect_db.php';

    $user = $_POST['nombre'] ?? '';
    $pass = $_POST['clave'] ?? '';

    if ($user && $pass) {
        $sth = $dbh->prepare('SELECT * FROM usuarios WHERE username = BINARY ? AND password = BINARY ?');
        $sth->execute([$user, $pass]);
        $resultado = $sth->fetch(PDO::FETCH_ASSOC);

        if ($resultado) {
            $_SESSION['usuario'] = $resultado['username'];
            $_SESSION['rol'] = $resultado['role'];
            $usuario = $_SESSION['usuario'];
            $conectado = true;
            $message = 'Has iniciado sesión correctamente.';
        } else {
            $message = 'El nombre de usuario o contraseña no es correcto.';
        }
    } else {
        $message = 'Por favor, ingresa nombre de usuario y contraseña.';
    }
}
?>

<?php require_once '../plantillas/navegacion.php'; ?>

<h2>Iniciar sesión</h2>

<?php if (isset($message)) { ?>
    <p><?= htmlspecialchars($message, ENT_QUOTES, 'UTF-8') ?></p>
<?php }

if (!$conectado) { ?>
    <form action='iniciar_sesion.php' method='post'>
        <label for='nombre'>Nombre de usuario:</label>
        <input type='text' name='nombre' id='nombre' required /><br />
        <label for='clave'>Contraseña:</label>
        <input type='password' name='clave' id='clave' required /><br />
        <input type='submit' value='Enviar' />
    </form>
<?php }

require_once '../plantillas/pie.php'; ?>
