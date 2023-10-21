// CONDICIONALES EN C#


// OPERADORES DE COMPARACIÓN

int a = 5;
int b = 3;

bool z = a == b;        // Igual a    Resultado: False
z = a != b;             // No igual a Resultado: True
z = a > b;              // Mayor que  Resultado: True
z = a >= b;             // Mayor o igual a        Resultado: True
z = a < b;              // Menor que  Resultado: False
z = a <= b;             // Menor o igual a        Resultado: False

// Se pueden comparar dos cadenas también. Por ejemplo, verifica: 'Patricia' == 'Patricia'  --> True
z = "Patricia" == "Patricia"; // True


// OPERADORES LÓGICOS

bool f = false;
bool t = true;

// Operador AND (&&)
z = f && f;             // Resultado: False
z = f && t;             // Resultado: False
z = t && f;             // Resultado: False
z = t && t;             // Resultado: True

// Operador OR (||)
z = f || f;             // Resultado: False
z = f || t;             // Resultado: True
z = t || f;             // Resultado: True
z = t || t;             // Resultado: True

// Operador NOT (!)
z = !f;                 // Resultado: True
z = !t;                 // Resultado: False


// COMBINACIÓN DE OPERADORES DE COMPARACIÓN Y LÓGICOS
z = !(a == b) || (a >= b && a != b);  // Resultado: True


// DECISIONES CON IF

int entero = 7;
int edad = 30;
float calificacion = 9.5f;

bool mayorQueCero = entero > 0;  // Resultado: true

if (mayorQueCero)  // Sentencia if
{
    Console.WriteLine("El número es positivo.");
}

if (entero > 0)  // Sentencia if (alternativa popular)
{
    Console.WriteLine("El número es positivo.");
}

if (edad >= 18)   // Sentencia if-else
{
    Console.WriteLine("Eres mayor de edad.");
}
else
{
    Console.WriteLine("No eres mayor de edad.");
}

if (calificacion < 5)  // Sentencia if-else-if
{
    Console.WriteLine("Reprobado.");
}
else if (calificacion >= 5 && calificacion < 7)
{
    Console.WriteLine("Aprobado.");
}
else if (calificacion >= 7 && calificacion < 9)
{
    Console.WriteLine("Notable.");
}
else
{
    Console.WriteLine("Excelente.");
}


// DECISIONES CON SWITCH-CASE

int opcion = 3;

switch (opcion)
{
    case 1:
        Console.WriteLine("El número es 1.");
        break;
    case 2:
        Console.WriteLine("El número es 2.");
        break;
    case 3:
        Console.WriteLine("El número es 3.");
        break;
    default:
        Console.WriteLine("El número no es 1, 2 ni 3.");
        break;
}


string fruta = "Manzana";

switch (fruta)
{
    case "Manzana":
        Console.WriteLine("La fruta es 'Manzana'.");
        break;
    case "Plátano":
        Console.WriteLine("La fruta es 'Plátano'.");
        break;
    case "Naranja":
        Console.WriteLine("La fruta es 'Naranja'.");
        break;
    default:
        Console.WriteLine("No reconozco esa fruta.");
        break;
}


// EJEMPLO 1 (IFS ANIDADOS): programa para verificar si el año introducido es bisiesto o no

int year = 2000;

if (year % 4 == 0)
{
    if (year % 100 == 0)
    {
        if (year % 400 == 0)
        {
Console.WriteLine(year + " es un año bisiesto.");
        }
        else
        {
Console.WriteLine(year + " no es un año bisiesto.");
        }
    }
    else
    {
        Console.WriteLine(year + " es un año bisiesto.");
    }
}
else
{
    Console.WriteLine(year + " no es un año bisiesto.");
}


// EJEMPLO 2: convertidor de Fahrenheit a Celsius y viceversa

string temperatura = "113.0F";

char unidad = temperatura[^1];
float valor = float.Parse(temperatura[..^1]);

if (unidad == 'C' || unidad == 'c')
{
    float fahrenheit = (valor * 1.8f) + 32;
    Console.WriteLine($"{fahrenheit} ºF");
}
else if (unidad == 'F' || unidad == 'f')
{
    float celsius = (valor - 32) / 1.8f;
    Console.WriteLine($"{celsius} ºC");
}
