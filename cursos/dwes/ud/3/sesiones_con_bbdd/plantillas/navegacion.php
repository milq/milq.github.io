<?php
$current_page = basename($_SERVER['PHP_SELF']);
$base_url = (basename(dirname($_SERVER['PHP_SELF'])) === 'acciones') ? '../' : '';

$menu_items = [
    'index.php'    => 'Inicio',
    'ver.php'      => 'Ver',
    'insertar.php' => 'Añadir',
    'editar.php'   => 'Editar',
    'borrar.php'   => 'Borrar'
];
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
            <a href="<?= htmlspecialchars($base_url . $file, ENT_QUOTES, 'UTF-8') ?>"><?= htmlspecialchars($title, ENT_QUOTES, 'UTF-8') ?></a>
        <?php }
        $first = false;
    }
    ?>
    <span>
        <?php if ($conectado) { ?>
            <?= htmlspecialchars($usuario, ENT_QUOTES, 'UTF-8') ?>
        <?php } else { ?>
            <a href='<?= $base_url ?>iniciar_sesion.php'>Iniciar sesión</a>
        <?php } ?>
         |
        <a href='<?= $base_url ?>cerrar_sesion.php'>Cerrar sesión</a>
    </span>
</nav>
