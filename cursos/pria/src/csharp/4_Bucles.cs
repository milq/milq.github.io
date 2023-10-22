// BUCLE CLÁSICO
Console.WriteLine("BUCLE CLÁSICO");
for (int i = 0; i < 10; i++)
{
    Console.Write($"i:{i}\t");
}
Console.WriteLine("\n");


// BUCLE CLÁSICO CON LISTAS
Console.WriteLine("BUCLE CLÁSICO CON LISTAS");
List<float> numeros = new List<float> { -3.2f, 5.3f, 3f, 1f };
for (int i = 0; i < numeros.Count; i++)
{
    Console.Write($"{numeros[i]}\t");
}
Console.WriteLine("\n");


// BUCLE INVERSO
Console.WriteLine("BUCLE INVERSO");
for (int i = 5; i >= 0; i--)
{
    Console.Write($"i:{i}\t");
}
Console.WriteLine("\n");


// BUCLE ANIDADO
Console.WriteLine("BUCLE ANIDADO");
for (int i = 0; i < 3; i++)
{
    Console.Write($"i:{i}\t");
    for (int j = 2; j > 0; j--)
    {
        Console.Write($"j:{j}\t");
        for (int k = 0; k < 2; k++)
        {
            Console.Write($"k:{k}\t");
        }
    }
}
Console.WriteLine("\n");


// BUCLE CON VARIOS CONTADORES
Console.WriteLine("BUCLE CON VARIOS CONTADORES");
for (int a = 0, b = 5; a < 5 && b > 0; a++, b--)
{
    Console.Write($"a:{a} b:{b}\t");
}
Console.WriteLine("\n");


// BUCLE ITERADOR
Console.WriteLine("BUCLE ITERADOR");
List<string> colores = new List<string> { "rojo", "verde", "azul", "amarillo" };
foreach (var color in colores)
{
    Console.Write($"{color}\t");
}
Console.WriteLine("\n");


// BUCLE WHILE
Console.WriteLine("BUCLE WHILE");
int contador = 0;
while (contador <= 3)
{
    contador++;
    Console.Write($"Hola {contador}\t");
}
Console.WriteLine("\n");


// BUCLE DO-WHILE
Console.WriteLine("BUCLE DO-WHILE");
contador = 0;
do
{
    contador++;
    Console.Write($"Adiós {contador}\t");
} while (contador <= 3);
Console.WriteLine("\n");


// EJEMPLO 1 (SUMATORIA)
Console.WriteLine("EJEMPLO 1 (SUMATORIA)");
List<float> miLista = new List<float> { -4.3f, 2f, -0.7f, 1.5f, 3.5f };
float suma = 0;
foreach (var num in miLista)
{
    suma += num;
}
Console.WriteLine($"La suma de todos los elementos de la lista es {suma}\n");


// EJEMPLO 2 (PRODUCTO)
Console.WriteLine("EJEMPLO 2 (PRODUCTO)");
List<float> listaProducto = new List<float> { 3f, 2f, -1f, 1f, 4f };
float producto = 1;
foreach (var num in listaProducto)
{
    producto *= num;
}
Console.WriteLine($"La multiplicación de todos los elementos de la lista es {producto}\n");


// EJEMPLO 3 (PRIMO)
Console.WriteLine("EJEMPLO 3 (PRIMO)");
List<int> listaEnteros = new List<int> { 4, 8, 15, 16, 23, 42 };
int numeroPrimo = -1;
foreach (var num in listaEnteros)
{
    bool esPrimo = true;
    if (num <= 1)
    {
        esPrimo = false;
    }
    else
    {
        for (int divisor = 2; divisor * divisor <= num; divisor++)
        {
            if (num % divisor == 0)
            {
                esPrimo = false;
                break;
            }
        }
    }

    if (esPrimo)
    {
        numeroPrimo = num;
        break;
    }
}
if (numeroPrimo != -1)
{
    Console.WriteLine($"El primer número primo en la lista es {numeroPrimo}\n");
}
else
{
    Console.WriteLine("No hay números primos en la lista.\n");
}


// EJEMPLO 4 (FACTORIAL)
Console.WriteLine("EJEMPLO 4 (FACTORIAL)");
int numero = 5;
long factorial = 1;
for (int i = 1; i <= numero; i++)
{
    factorial *= i;
}
Console.WriteLine($"El factorial de {numero} es {factorial}.");
