// Esto es un comentario de una línea

/*
   Esto es un comentario
   de múltiples líneas
*/

// VARIABLES
// Una variable es un símbolo que representa una cantidad que puede variar.
// En C#, la sintaxis general para declarar una variable es:
// tipoDeDato nombreVariable = valor;

int edad = 25;  // La edad es un número entero, por eso usamos "int"



// TIPOS DE DATOS BÁSICOS

int nivelDelMar = 25;              // Entero (Integer)
float temperatura = -3.82f;        // Número real (Float)
string nombre = "Nacho López";     // Cadena de texto (String)
bool tieneCoche = true;            // Booleano (Boolean): solo puede ser 'true' o 'false'



// OPERACIONES ARITMÉTICAS CON NÚMEROS

int x = 5;
int y = 2;

int z;
z = x + y;          // Suma.                                 Resultado: 7
z = x - y;          // Resta.                                Resultado: 3
z = x * y;          // Multiplicación.                       Resultado: 10
z = x / y;          // División.                             Resultado: 2 (Nota: la división entre enteros redondea al entero más cercano)
z = x % y;          // Módulo (resto de la división).        Resultado: 1

z = z + 1;          // Incrementa el valor de z en 1.        Resultado: 2
z = z - 1;          // Disminuye el valor de z en 1.         Resultado: 1

// Nota: En la división, si deseas obtener un resultado con decimales, uno de los números debe ser de tipo float o double:
float resultadoDivision = 5.0f / 2.0f;  // Resultado: 2.5



// OPERACIONES BÁSICAS CON CADENAS DE TEXTO (strings)

string a = "GNU/";
string b = "Linux";
string c = a + b;  // Concatenación. Resultado: "GNU/Linux"


// IMPRIMIR VARIABLES EN LA PANTALLA

Console.WriteLine("¡Hola, mundo!");   // Imprime en la pantalla: ¡Hola, mundo!
Console.WriteLine(x);                 // Imprime el valor de x

// Puedes imprimir en la pantalla cadenas de texto y variables
Console.WriteLine("He comprado " + x + " naranjas y " + y + " limones.");



// CONVERSIÓN DE TIPOS DE DATOS

string posicion = "5";
string calorias = "95.4";
int peso = 85;
float altitud = -544.432f;

int posicionInt1 = Convert.ToInt32(posicion);     // Convertir a entero
float caloriasFlt1 = Convert.ToSingle(calorias);  // Convertir a número real (float)
string pesoStr1 = Convert.ToString(peso);         // Convertir a cadena de texto (string)
string altitudStr1 = Convert.ToString(altitud);   // Convertir a cadena de texto (string)

int posicionInt2 = int.Parse(posicion);      // Convertir a entero
float caloriasFlt2 = float.Parse(calorias);  // Convertir a número real (float)
string pesoStr2 = peso.ToString();           // Convertir a cadena de texto (string)
string altitudStr2 = altitud.ToString();     // Convertir a cadena de texto (string)

// Obtener el tipo de dato de las variables
Type tipoPosicion1 = posicionInt1.GetType();  // Tipo: System.Int32
Type tipoCalorias1 = caloriasFlt1.GetType();  // Tipo: System.Single (float)
Type tipoPeso1 = pesoStr1.GetType();          // Tipo: System.String
Type tipoAltitud1 = altitudStr1.GetType();    // Tipo: System.String

Type tipoPosicion2 = posicionInt2.GetType();  // Tipo: System.Int32
Type tipoCalorias2 = caloriasFlt2.GetType();  // Tipo: System.Single (float)
Type tipoPeso2 = pesoStr2.GetType();          // Tipo: System.String
Type tipoAltitud2 = altitudStr2.GetType();    // Tipo: System.String

Console.WriteLine(tipoPosicion1);
Console.WriteLine(tipoCalorias1);
Console.WriteLine(tipoPeso1);
Console.WriteLine(tipoAltitud1);

Console.WriteLine(tipoPosicion2);
Console.WriteLine(tipoCalorias2);
Console.WriteLine(tipoPeso2);
Console.WriteLine(tipoAltitud2);

Console.WriteLine("Mi nombre es " + nombre + ", tengo " + edad + " años y estoy a " + nivelDelMar + " metros sobre el nivel del mar, donde la temperatura es de " + temperatura + " grados Celsius. ¿Tengo coche? " + tieneCoche + ". Y por cierto, el resultado de una división que hice antes es de " + resultadoDivision + ".");
