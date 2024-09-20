<?php

// BUCLE CLÁSICO
echo "BUCLE CLÁSICO\n";
for ($i = 0; $i < 10; $i++) {
    echo "i:{$i}\t";
}
echo "\n\n";

// BUCLE CLÁSICO CON ARRAYS
echo "BUCLE CLÁSICO CON ARRAYS\n";
$numeros = [-3.2, 5.3, 3.0, 1.0];
for ($i = 0; $i < count($numeros); $i++) {
    echo "{$numeros[$i]}\t";
}
echo "\n\n";

// BUCLE INVERSO
echo "BUCLE INVERSO\n";
for ($i = 5; $i >= 0; $i--) {
    echo "i:{$i}\t";
}
echo "\n\n";

// BUCLE ANIDADO
echo "BUCLE ANIDADO\n";
for ($i = 0; $i < 3; $i++) {
    echo "i:{$i}\t";
    for ($j = 2; $j > 0; $j--) {
        echo "j:{$j}\t";
        for ($k = 0; $k < 2; $k++) {
            echo "k:{$k}\t";
        }
    }
}
echo "\n\n";

// BUCLE CON VARIOS CONTADORES
echo "BUCLE CON VARIOS CONTADORES\n";
for ($a = 0, $b = 5; $a < 5 && $b > 0; $a++, $b--) {
    echo "a:{$a} b:{$b}\t";
}
echo "\n\n";

// BUCLE ITERADOR
echo "BUCLE ITERADOR\n";
$colores = ["rojo", "verde", "azul", "amarillo"];
foreach ($colores as $color) {
    echo "{$color}\t";
}
echo "\n\n";

// BUCLE WHILE
echo "BUCLE WHILE\n";
$contador = 0;
while ($contador <= 3) {
    $contador++;
    echo "Hola {$contador}\t";
}
echo "\n\n";

// BUCLE DO-WHILE
echo "BUCLE DO-WHILE\n";
$contador = 0;
do {
    $contador++;
    echo "Adiós {$contador}\t";
} while ($contador <= 3);
echo "\n\n";

// EJEMPLO 1 (SUMATORIA)
echo "EJEMPLO 1 (SUMATORIA)\n";
$miLista = [-4.3, 2.0, -0.7, 1.5, 3.5];
$suma = 0;
foreach ($miLista as $num) {
    $suma += $num;
}
echo "La suma de todos los elementos de la lista es {$suma}\n\n";

// EJEMPLO 2 (PRODUCTO)
echo "EJEMPLO 2 (PRODUCTO)\n";
$listaProducto = [3.0, 2.0, -1.0, 1.0, 4.0];
$producto = 1;
foreach ($listaProducto as $num) {
    $producto *= $num;
}
echo "La multiplicación de todos los elementos de la lista es {$producto}\n\n";

// EJEMPLO 3 (PRIMO)
echo "EJEMPLO 3 (PRIMO)\n";
$listaEnteros = [4, 8, 15, 16, 23, 42];
$numeroPrimo = -1;
foreach ($listaEnteros as $num) {
    $esPrimo = true;
    if ($num <= 1) {
        $esPrimo = false;
    } else {
        for ($divisor = 2; $divisor * $divisor <= $num; $divisor++) {
            if ($num % $divisor == 0) {
                $esPrimo = false;
                break;
            }
        }
    }
    if ($esPrimo) {
        $numeroPrimo = $num;
        break;
    }
}
if ($numeroPrimo !== -1) {
    echo "El primer número primo en la lista es {$numeroPrimo}\n\n";
} else {
    echo "No hay números primos en la lista.\n\n";
}

// EJEMPLO 4 (FACTORIAL)
echo "EJEMPLO 4 (FACTORIAL)\n";
$numero = 5;
$factorial = 1;
for ($i = 1; $i <= $numero; $i++) {
    $factorial *= $i;
}
echo "El factorial de {$numero} es {$factorial}.\n";
