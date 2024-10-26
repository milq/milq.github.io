<?php
$titulo_pagina = isset($titulo_pagina) ? $titulo_pagina : 'Hash y Cookies';

$subdir = basename(dirname($_SERVER['PHP_SELF']));
$css_path = ($subdir === 'acciones' || $subdir === 'sesiones') ? '../estilo.css' : 'estilo.css';
?>

<!DOCTYPE html>
<html lang='es'>
  <head>
    <meta charset='utf-8' />
    <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=2.0' />
    <link rel='stylesheet' href='<?php echo htmlspecialchars($css_path, ENT_QUOTES, 'UTF-8'); ?>'>
    <title><?php echo htmlspecialchars($titulo_pagina); ?> - Sesiones, Hash y Cookies</title>
  </head>
  <body>
    <h1>Sesiones, <em>hash</em> y <em>cookies</em></h1>
