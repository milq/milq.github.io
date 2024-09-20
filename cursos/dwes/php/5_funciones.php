<?php

///////////////
// FUNCIONES //
///////////////

function saludar(): void
{
    echo "¡Hola, mundo!\n";
}

function cuadrado(int $numero): int
{
    return $numero * $numero;
}

function suma(int $a, int $b): int
{
    return $a + $b;
}

function producto(int $a, int $b, int $c): int
{
    return $a * $b * $c;
}

function mediaCuadradoOrden(array $numeros, int $n, array $cadenas): array
{
    $media = array_sum($numeros) / count($numeros);
    $cuadrado = cuadrado($n);

    $cadenasOrdenadas = $cadenas;
    sort($cadenasOrdenadas);

    return [$media, $cuadrado, $cadenasOrdenadas];
}

function factorial(int $numero): int
{
    if ($numero <= 1) {
        return 1;
    }
    return $numero * factorial($numero - 1);
}

//////////////
// PROGRAMA //
//////////////

saludar();

$x = 2;
$cuadrado = cuadrado($x);
echo "\nEl cuadrado de $x es $cuadrado.\n\n";

$suma = suma(cuadrado(2), 3);
echo "La suma de " . cuadrado(2) . " y 3 es $suma.\n\n";

$producto = producto(4, suma(2, cuadrado(1)), 2);
echo "El resultado de la función 'producto' con los valores proporcionados es $producto.\n\n";

$latitudes = [-2.4, 7.4, 3.0, 4.6, -5.0];
$numero = suma(1, 1);
$clima = ["soleado", "nublado", "ventoso", "lluvioso"];
$resultado = mediaCuadradoOrden($latitudes, $numero, $clima);

echo "Resultado de la función 'MediaCuadradoOrden':\n";
echo "Media de las latitudes: " . $resultado[0] . "\n";
echo "Cuadrado del número: " . $resultado[1] . "\n";
echo "Climas ordenados: " . implode(", ", $resultado[2]) . "\n\n";

echo "El factorial de " . $resultado[1] . " es " . factorial((int)$resultado[1]) . ".\n";
