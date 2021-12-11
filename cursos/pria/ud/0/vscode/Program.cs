// 3. BUCLES
// =========

// ACTIVIDADES DE INICIACIÓN

// 1. Crea un programa que determine si dos variables de tipo numérico son iguales o no.

int a = 5;
int b = 3;

if (a == b) {
    Console.WriteLine("La variable 'a' y 'b' son iguales.");
} else {
    Console.WriteLine("Las variables 'a' y 'b' no son iguales.");
}


// 2. Crea un programa que determine si un número entero es par o impar (pista: usar la operación %).

int c = 6;

if (c % 2 == 0) {
    Console.WriteLine("El entero 'c' es par.");
} else {
    Console.WriteLine("El entero 'c' es impar.");
}


// 3. Crea un programa que determine si una variable de tipo numérico es positiva, negativa o cero.

// [...]



// ACTIVIDADES DE DESARROLLO

// 11. Dado dos enteros, calcula la suma. Si el resultado está entre 10 y 19 (ambos incluídos), imprime 20. Si no, imprime la suma.

String args0 = args[0];
String args1 = args[1];

int x = int.Parse(args0);
int y = int.Parse(args1);

int suma = x + y;

if (suma >= 10 && suma <= 19) {
    Console.WriteLine(20);
} else {
    Console.WriteLine(suma);
}


// 12. Dado tres enteros, devuelve verdadero si no aparece ni un 1 y ni un 3.

// [...]