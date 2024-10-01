<?php

///////////////////////////
// ARRAYS EN PHP         //
///////////////////////////

// CREAR UN ARRAY Y OBTENER ELEMENTOS DE ÉL

// En PHP, un array numérico es un array indexado con claves numéricas, empezando desde 0 por defecto.
$alimentos = ["naranjas", "fresas", "limones"];

// Acceder a elementos del array mediante su índice
$a = $alimentos[0];
$b = $alimentos[1];
$c = $alimentos[2];

echo "Me gustan las $a, las $b y los $c\n";

// IMPRIMIR EN PANTALLA UN ARRAY

// Imprimir usando print_r: imprime la estructura del array con formato legible,
// mostrando los índices y sus valores de manera clara.
print_r($alimentos);

// Imprimir usando implode: convierte el array en una cadena de texto
// uniendo sus elementos con una coma y un espacio ", ".
echo implode(", ", $alimentos) . "\n";


//////////////////////////////////////////////////////////////////////////////////////
// CONTAR ELEMENTOS EN UN ARRAY
//////////////////////////////////////////////////////////////////////////////////////

$frutas = ["Manzana", "Plátano", "Sandía", "Melocotón", "Nectarina"];
$numFrutas = count($frutas);
echo "Número de frutas: $numFrutas\n";


//////////////////////////////////////////////////////////////////////////////////////
// MODIFICAR UN ELEMENTO DE UN ARRAY
//////////////////////////////////////////////////////////////////////////////////////

$edades = [43, 72, 32, 22, 65];

$edades[3] = 57;
$edades[0] = 6;
$edades[count($edades) - 1] = 12;

echo implode(", ", $edades) . "\n";


//////////////////////////////////////////////////////////////////////////////////////
// AÑADIR UN ELEMENTO A UN ARRAY
//////////////////////////////////////////////////////////////////////////////////////

$nombres = ["Nacho", "David", "Lola"];

// Insertar "Alba" en la posición 2
array_splice($nombres, 2, 0, "Alba");

// Insertar "Álvaro" en la posición 0
array_splice($nombres, 0, 0, "Álvaro");

// Añadir "Marta" al final del array
$nombres[] = "Marta";  // También puedes usar array_push($nombres, "Marta");

echo implode(", ", $nombres) . "\n";


//////////////////////////////////////////////////////////////////////////////////////
// ELIMINAR ELEMENTOS DE UN ARRAY
//////////////////////////////////////////////////////////////////////////////////////

$colores = ["Azul", "Naranja", "Verde", "Amarillo", "Blanco"];

// Eliminar el elemento con índice 0
array_splice($colores, 0, 1);
// array_shift($colores);    // Otra opción alternativa

// Eliminar el elemento con índice 2
array_splice($colores, 2, 1);

// Eliminar el último elemento
array_splice($colores, -1);
// array_pop($colores);    // Otra opción alternativa

echo implode(", ", $colores) . "\n";

$letras = ["A", "B", "A", "B", "C", "B"];

// Eliminar la primera ocurrencia de "B"
$index = array_search("B", $letras);
if ($index !== false) {
    unset($letras[$index]);
    // Reindexar el array
    $letras = array_values($letras);
}
echo "Después de eliminar la primera 'B': " . implode(", ", $letras) . "\n";

// Limpiar el array
$letras = [];  // o $letras = array();
echo "Después de limpiar la lista de letras: " . implode(", ", $letras) . "\n";


//////////////////////////////////////////////////////////////////////////////////////
// ORDENAR UN ARRAY
//////////////////////////////////////////////////////////////////////////////////////

$enteros = [43, 72, 32, 22, 65];
echo "Lista de enteros antes de ordenar:\n";
echo implode(", ", $enteros) . "\n";

// Ordenar el array en orden ascendente
sort($enteros);

echo "Lista de números después de ordenar:\n";
echo implode(", ", $enteros) . "\n";


//////////////////////////////////////////////////////////////////////////////////////
// INVERTIR UN ARRAY
//////////////////////////////////////////////////////////////////////////////////////

$animales = ["Perro", "Gato", "Pájaro", "Pez"];
echo "Lista de animales antes de invertir:\n";
echo implode(", ", $animales) . "\n";

// Invertir el orden de los elementos
$animales_invertidos = array_reverse($animales);

echo "Lista de animales después de invertir:\n";
echo implode(", ", $animales_invertidos) . "\n";


//////////////////////////////////////////////////////////////////////////////////////
// SUBARRAYS
//////////////////////////////////////////////////////////////////////////////////////

$listaEnteros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Obtener una sublista que comienza en el índice 2 con 5 elementos
$subLista = array_slice($listaEnteros, 2, 5);

echo "Sublista:\n";
echo implode(", ", $subLista) . "\n";


//////////////////////////////////////////////////////////////////////////////////////
// ARRAYS VACÍOS
//////////////////////////////////////////////////////////////////////////////////////

$listaVacia = [];
echo "La lista vacía tiene " . count($listaVacia) . " elementos.\n";


//////////////////////////////////////////////////////////////////////////////////////
// ARRAYS MULTIDIMENSIONALES
//////////////////////////////////////////////////////////////////////////////////////

$matriz = [
    ["a", "b", "c"],
    ["d", "e", "f"],
    ["g", "h", "i"]
];

echo "Elemento en la posición (1,2) de la matriz:\n";
echo $matriz[1][2] . "\n";  // Devuelve "f"


//////////////////////////////////////////////////////////////////////////////////////
// ARRAYS VACÍOS MULTIDIMENSIONALES
//////////////////////////////////////////////////////////////////////////////////////

$listaVaciaMultidimensional = [];

// Añadir arrays vacíos al array multidimensional
$listaVaciaMultidimensional[] = [];
$listaVaciaMultidimensional[] = [];

echo "La lista vacía multidimensional tiene " . count($listaVaciaMultidimensional) . " elementos.\n";


//////////////////////////////////////////////////////////////////////////////////////
// SABER SI EL ARRAY CONTIENE UN ELEMENTO
//////////////////////////////////////////////////////////////////////////////////////

if (in_array("Alba", $nombres)) {
    echo "Alba está en la lista de nombres.\n";
} else {
    echo "Alba no está en la lista de nombres.\n";
}


//////////////////////////////////////////////////////////////////////////////////////
// OBTENER EL MÍNIMO Y MÁXIMO DE UN ARRAY
//////////////////////////////////////////////////////////////////////////////////////

$numeros = [5, 3, 8, 2, 6];
$minimo = min($numeros);
$maximo = max($numeros);

echo "El número mínimo es: $minimo\n";
echo "El número máximo es: $maximo\n";


//////////////////////////////////////////////////////////////////////////////////////
// SUMAR LOS ELEMENTOS DE UN ARRAY CON "SUM"
//////////////////////////////////////////////////////////////////////////////////////

$listaNumeros = [10, 20, 30, 40, 50];
$sumaTotal = array_sum($listaNumeros);

echo "La suma total de los números en la lista es: $sumaTotal\n";


//////////////////////////////////////////////////////////////////////////////////////
// ARRAYS EN PHP: NUMÉRICOS, ASOCIATIVOS Y COMBINADOS
//////////////////////////////////////////////////////////////////////////////////////

// ARRAY NUMÉRICO

$numeros = [1, 2, 3, 4, 5];
// Los índices son numéricos y empiezan desde 0
echo $numeros[0] . PHP_EOL;  // Imprime 1


// ARRAY ASOCIATIVO

$persona = [
    "nombre" => "Juan",
    "edad" => 30,
    "ciudad" => "Madrid"
];
// Accedemos a los elementos mediante claves asociativas
echo $persona["nombre"] . PHP_EOL;  // Imprime "Juan"


// ARRAY COMBINADO

$miArray = [
    // Índices numéricos
    0 => 'valor índice 0',
    1 => 'valor índice 1',
    2 => 'valor índice 2',
    3 => 'valor índice 3',
    4 => 'valor índice 4',

    // Claves asociativas
    'clave0' => 'valor clave 0',
    'clave1' => 'valor clave 1',
    'clave2' => 'valor clave 2',
    'clave3' => 'valor clave 3',
    'clave4' => 'valor clave 4',
];

// Tiene tanto claves numéricas como asociativas
echo $miArray["clave1"] . PHP_EOL;  // Imprime "valor clave 1"
echo $miArray[0] . PHP_EOL;         // Imprime "valor índice 0"
