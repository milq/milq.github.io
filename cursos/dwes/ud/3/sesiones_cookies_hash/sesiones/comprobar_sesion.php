<?php

session_start();

$conectado = false;
$usuario = '';

if (isset($_SESSION['usuario'])) {
    $conectado = true;
    $usuario = $_SESSION['usuario'];
}

?>
