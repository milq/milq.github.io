<?php

$título_página = isset($título_página) ? $título_página : 'Mensajes';

?>

<!DOCTYPE html>
<html lang='es'>
  <head>
    <meta charset='utf-8' />
    <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=2.0' />
    <link rel='stylesheet' href='estilo.css'>
    <title><?php echo htmlspecialchars($título_página); ?> - Mensajes</title>
  </head>
  <body>
    <h1>Mensajes</h1>
