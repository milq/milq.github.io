<?php

session_start();

$conectado = false;
$es_admin = false;
$usuario = '';

if (isset($_SESSION['usuario'], $_SESSION['rol'])) {
    $conectado = true;
    $usuario = $_SESSION['usuario'];
    $es_admin = $_SESSION['rol'] === 'admin';
}

?>
