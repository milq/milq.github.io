<?php

// Esto es un comentario de una línea

/*
   Esto es un comentario
   de múltiples líneas
*/

// VARIABLES
// Una variable es un símbolo que representa una cantidad que puede variar.
// En PHP, la sintaxis general para declarar una variable es usando el símbolo $ antes del nombre de la variable.

$edad = 25;  // La edad es un número entero, en PHP no es necesario declarar el tipo de dato.


// TIPOS DE DATOS BÁSICOS

$nivelDelMar = 25;              // Entero (Integer)
$temperatura = -3.82;           // Número real (Float)
$nombre = 'Nacho López';        // Cadena de texto (String)
$usaDebian = true;              // Booleano (Boolean): solo puede ser 'true' o 'false'


// OPERACIONES ARITMÉTICAS CON NÚMEROS

$x = 5;
$y = 2;

$z = $x + $y;        // Suma.                                 Resultado: 7
$z = $x - $y;        // Resta.                                Resultado: 3
$z = $x * $y;        // Multiplicación.                       Resultado: 10
$z = intdiv($x, $y); // División entera.                      Resultado: 2 (En PHP 8 puedes usar intdiv para la división entera)
$z = $x % $y;        // Módulo (resto de la división).        Resultado: 1

$z = $z + 1;         // Incrementa el valor de z en 1.        Resultado: 2
$z = $z - 1;         // Disminuye el valor de z en 1.         Resultado: 1

// Nota: En la división, si deseas obtener un resultado con decimales, uno de los números debe ser de tipo float:
$resultadoDivision = 5.0 / 2.0;  // Resultado: 2.5


// OPERACIONES BÁSICAS CON CADENAS DE TEXTO (strings)

$a = 'GNU/';
$b = 'Linux';
$c = $a . $b;  // Concatenación. Resultado: 'GNU/Linux'


// IMPRIMIR VARIABLES EN LA PANTALLA

echo '¡Hola, mundo!';  // Imprime en la pantalla: ¡Hola, mundo!
echo PHP_EOL;          // Imprime en la pantalla un salto de línea
echo $x;               // Imprime el valor de x
echo PHP_EOL;

// Puedes imprimir en la pantalla cadenas de texto y variables
echo 'He comprado ' . $x . ' naranjas y ' . $y . ' limones.' . PHP_EOL;

// CONVERSIÓN DE TIPOS DE DATOS

$posicion = '5';
$calorias = '95.4';
$peso = 85;
$altitud = -544.432;

$posicionInt1 = intval($posicion);      // Convertir a entero
$caloriasFlt1 = floatval($calorias);    // Convertir a número real (float)
$pesoStr1 = strval($peso);              // Convertir a cadena de texto (string)
$altitudStr1 = strval($altitud);        // Convertir a cadena de texto (string)

$posicionInt2 = (int)$posicion;         // Convertir a entero
$caloriasFlt2 = (float)$calorias;       // Convertir a número real (float)
$pesoStr2 = (string)$peso;              // Convertir a cadena de texto (string)
$altitudStr2 = (string)$altitud;        // Convertir a cadena de texto (string)

// Obtener el tipo de dato de las variables (gettype en PHP)
$tipoPosicion1 = gettype($posicionInt1);   // Tipo: integer
$tipoCalorias1 = gettype($caloriasFlt1);   // Tipo: double
$tipoPeso1 = gettype($pesoStr1);           // Tipo: string
$tipoAltitud1 = gettype($altitudStr1);     // Tipo: string

$tipoPosicion2 = gettype($posicionInt2);   // Tipo: integer
$tipoCalorias2 = gettype($caloriasFlt2);   // Tipo: double
$tipoPeso2 = gettype($pesoStr2);           // Tipo: string
$tipoAltitud2 = gettype($altitudStr2);     // Tipo: string

echo $tipoPosicion1 . PHP_EOL;
echo $tipoCalorias1 . PHP_EOL;
echo $tipoPeso1 . PHP_EOL;
echo $tipoAltitud1 . PHP_EOL;

echo $tipoPosicion2 . PHP_EOL;
echo $tipoCalorias2 . PHP_EOL;
echo $tipoPeso2 . PHP_EOL;
echo $tipoAltitud2 . PHP_EOL;


// MENSAJE FINAL PARA EVITAR VARIABLES NO USADAS

echo 'Mi nombre es ' . $nombre . ', tengo ' . $edad . ' años y estoy a ' . $nivelDelMar . ' metros sobre el nivel del mar, donde la temperatura es de ' . $temperatura . ' grados Celsius. ¿Uso Debian GNU/Linux? ' . ($usaDebian ? 'Sí' : 'No') . '. Y por cierto, el resultado de una división que hice antes es de ' . $resultadoDivision . '.' . PHP_EOL;
