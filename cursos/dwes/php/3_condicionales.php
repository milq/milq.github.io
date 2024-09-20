<?php

// CONDICIONALES EN PHP

// OPERADORES DE COMPARACIÓN

$a = 5;
$b = 3;

$z = $a == $b;        // Igual a                Resultado: false
$z = $a != $b;        // No igual a             Resultado: true
$z = $a > $b;         // Mayor que              Resultado: true
$z = $a >= $b;        // Mayor o igual a        Resultado: true
$z = $a < $b;         // Menor que              Resultado: false
$z = $a <= $b;        // Menor o igual a        Resultado: false

// Se pueden comparar dos cadenas también. Por ejemplo, verifica: 'Patricia' == 'Patricia' --> true
$z = "Patricia" == "Patricia"; // true


// OPERADORES LÓGICOS

$f = false;
$t = true;

// Operador AND (&&)
$z = $f && $f; // Resultado: false
$z = $f && $t; // Resultado: false
$z = $t && $f; // Resultado: false
$z = $t && $t; // Resultado: true

// Operador OR (||)
$z = $f || $f; // Resultado: false
$z = $f || $t; // Resultado: true
$z = $t || $f; // Resultado: true
$z = $t || $t; // Resultado: true

// Operador NOT (!)
$z = !$f; // Resultado: true
$z = !$t; // Resultado: false

// COMBINACIÓN DE OPERADORES DE COMPARACIÓN Y LÓGICOS
$z = !($a == $b) || ($a >= $b && $a != $b); // Resultado: true


// DECISIONES CON IF

$entero = 7;
$edad = 30;
$calificacion = 9.5;

$mayorQueCero = $entero > 0; // Resultado: true

if ($mayorQueCero) { // Sentencia if
    echo "El número es positivo.\n";
}

if ($entero > 0) { // Sentencia if (alternativa más popular)
    echo "El número es positivo.\n";
}

if ($edad >= 18) { // Sentencia if-else
    echo "Eres mayor de edad.\n";
} else {
    echo "No eres mayor de edad.\n";
}

if ($calificacion < 5) { // Sentencia if-else-if
    echo "Suspenso.\n";
} elseif ($calificacion >= 5 && $calificacion < 7) {
    echo "Aprobado.\n";
} elseif ($calificacion >= 7 && $calificacion < 9) {
    echo "Notable.\n";
} else {
    echo "Excelente.\n";
}


// DECISIONES CON SWITCH-CASE

$opcion = 3;

switch ($opcion) {
    case 1:
        echo "El número es 1.\n";
        break;
    case 2:
        echo "El número es 2.\n";
        break;
    case 3:
        echo "El número es 3.\n";
        break;
    default:
        echo "El número no es 1, 2 ni 3.\n";
        break;
}

$fruta = "Manzana";

switch ($fruta) {
    case "Manzana":
        echo "La fruta es 'Manzana'.\n";
        break;
    case "Plátano":
        echo "La fruta es 'Plátano'.\n";
        break;
    case "Naranja":
        echo "La fruta es 'Naranja'.\n";
        break;
    default:
        echo "No reconozco esa fruta.\n";
        break;
}


// EJEMPLO 1 (IFS ANIDADOS): programa para verificar si el año introducido es bisiesto o no

$year = 2000;

if ($year % 4 == 0) {
    if ($year % 100 == 0) {
        if ($year % 400 == 0) {
            echo $year . " es un año bisiesto.\n";
        } else {
            echo $year . " no es un año bisiesto.\n";
        }
    } else {
        echo $year . " es un año bisiesto.\n";
    }
} else {
    echo $year . " no es un año bisiesto.\n";
}


// EJEMPLO 2: convertidor de Fahrenheit a Celsius y viceversa

$temperatura = "113.0F";

$unidad = $temperatura[-1];
$valor = (float) substr($temperatura, 0, -1);

if ($unidad == 'C' || $unidad == 'c') {
    $fahrenheit = ($valor * 1.8) + 32;
    echo "{$fahrenheit} ºF\n";
} elseif ($unidad == 'F' || $unidad == 'f') {
    $celsius = ($valor - 32) / 1.8;
    echo "{$celsius} ºC\n";
}


// DIFERENCIAS ENTRE == Y ===

// Con números
$x = 5;
$y = "5";

$z = $x == $y;   // true, porque compara el valor sin considerar el tipo
$z = $x === $y;  // false, porque compara el valor y el tipo (int vs string)

// Con cadenas
$cadena1 = "Patricia";
$cadena2 = "patricia";

$z = $cadena1 == $cadena2;   // false, las cadenas son sensibles a mayúsculas y minúsculas
$z = $cadena1 === $cadena2;  // false, además del valor, el tipo es el mismo (string), pero los valores difieren

$cadena3 = "Patricia";
$cadena4 = "Patricia";

$z = $cadena3 == $cadena4;   // true, los valores son iguales
$z = $cadena3 === $cadena4;  // true, los valores y los tipos son iguales

// Con tipos diferentes
$booleano = true;
$numero = 1;

$z = $booleano == $numero;   // true, true se convierte a 1 en comparación flexible
$z = $booleano === $numero;  // false, tipos diferentes (bool vs int)
