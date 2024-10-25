<?php

$host = 'localhost';
$dbname = 'dwes_ejemplo_mensajes';
$username = 'root';
$password = '';

try
{
  $dbh = new PDO('mysql:host=' . $host . ';dbname=' . $dbname, $username, $password);
}
catch (PDOException $e)
{
  echo 'Error: ' . $e->getMessage();
}
?>
