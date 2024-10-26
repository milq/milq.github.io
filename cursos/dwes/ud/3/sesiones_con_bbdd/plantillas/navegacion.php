<?php
$current_page = basename($_SERVER['PHP_SELF']);
$subdirectory = basename(dirname($_SERVER['PHP_SELF']));

if ($subdirectory === 'acciones') {
    $menu_items = [
        '../index.php'    => 'Inicio',
        'ver.php'         => 'Ver',
        'insertar.php'    => 'Añadir',
        'editar.php'      => 'Editar',
        'borrar.php'      => 'Borrar'
    ];
    $login_url = '../sesiones/iniciar_sesion.php';
    $logout_url = '../sesiones/cerrar_sesion.php';
} elseif ($subdirectory === 'sesiones') {
    $menu_items = [
        '../index.php'         => 'Inicio',
        '../acciones/ver.php'  => 'Ver',
        '../acciones/insertar.php' => 'Añadir',
        '../acciones/editar.php'   => 'Editar',
        '../acciones/borrar.php'   => 'Borrar'
    ];
    $login_url = 'iniciar_sesion.php';
    $logout_url = 'cerrar_sesion.php';
} else {
    $menu_items = [
        'index.php'           => 'Inicio',
        'acciones/ver.php'    => 'Ver',
        'acciones/insertar.php' => 'Añadir',
        'acciones/editar.php' => 'Editar',
        'acciones/borrar.php' => 'Borrar'
    ];
    $login_url = 'sesiones/iniciar_sesion.php';
    $logout_url = 'sesiones/cerrar_sesion.php';
}
?>
<nav>
    <?php
    $first = true;
    foreach ($menu_items as $file => $title) {
        if (!$first) {
            ?> | <?php
        }
        if ($file === $current_page) { ?>
            <?= htmlspecialchars($title, ENT_QUOTES, 'UTF-8') ?>
        <?php } else { ?>
            <a href="<?= htmlspecialchars($file, ENT_QUOTES, 'UTF-8') ?>"><?= htmlspecialchars($title, ENT_QUOTES, 'UTF-8') ?></a>
        <?php }
        $first = false;
    }
    ?>
    <span>
        <?php
        if ($conectado) {
            echo htmlspecialchars($usuario, ENT_QUOTES, 'UTF-8');
        } else {
            if ($login_url === $current_page) { ?>
                Iniciar sesión
            <?php } else { ?>
                <a href="<?= htmlspecialchars($login_url, ENT_QUOTES, 'UTF-8') ?>">Iniciar sesión</a>
            <?php }
        }
        ?>
         |
        <?php
        if ($logout_url === $current_page) { ?>
            Cerrar sesión
        <?php } else { ?>
            <a href="<?= htmlspecialchars($logout_url, ENT_QUOTES, 'UTF-8') ?>">Cerrar sesión</a>
        <?php } ?>
    </span>
</nav>
