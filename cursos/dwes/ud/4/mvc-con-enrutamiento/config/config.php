<?php

define('SITE_NAME', 'MVC con enrutamiento');

define('APP_ROOT', dirname(dirname(__FILE__)));
define('URL_ROOT', '/');
define('BASE_PATH', ltrim(str_replace('/public', '', dirname($_SERVER['SCRIPT_NAME'])), '/'));

define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_NAME', 'dwes_proyecto_4_gestion_transacciones');
