//////////////////////////////////////////////////////////////////////////////////////
// LISTAS: https://learn.microsoft.com/dotnet/api/system.collections.generic.list-1 //
//////////////////////////////////////////////////////////////////////////////////////

// CREAR UNA LISTA Y OBTENER ELEMENTOS DE ELLA

List<string> alimentos = new List<string> { "naranjas", "fresas", "limones" };

string a = alimentos[0];
string b = alimentos[1];
string c = alimentos[2];

Console.WriteLine($"Me gustan las {a}, las {b} y los {c}");


// CONTAR ELEMENTOS EN UNA LISTA

List<string> frutas = new List<string> { "Manzana", "Plátano", "Sandía", "Melocotón", "Nectarina" };
int numFrutas = frutas.Count;
Console.WriteLine($"Número de frutas: {numFrutas}");


// MODIFICAR UN ELEMENTO DE LA LISTA

List<int> edades = new List<int> { 43, 72, 32, 22, 65 };

edades[3] = 57;
edades[0] = 6;
edades[edades.Count - 1] = 12;

Console.WriteLine(string.Join(", ", edades));


// AÑADIR UN ELEMENTO A LA LISTA

List<string> nombres = new List<string> { "Nacho", "David", "Lola" };

nombres.Insert(2, "Alba");
nombres.Insert(0, "Álvaro");
nombres.Add("Marta");

Console.WriteLine(string.Join(", ", nombres));


// ELIMINAR ELEMENTOS DE UNA LISTA

List<string> colores = new List<string> { "Azul", "Naranja", "Verde", "Amarillo", "Blanco" };

colores.RemoveAt(0);  // Elimina el elemento con índice 0 de la lista
colores.RemoveAt(2);  // Elimina el elemento con índice 2 de la lista
colores.RemoveAt(colores.Count - 1);

Console.WriteLine(string.Join(", ", colores));

List<string> letras = new List<string> { "A", "B", "A", "B", "C", "B" };

letras.Remove("B");  // Elimina el primer elemento de "B" que encuentre en la lista
Console.WriteLine($"Después de eliminar la primera 'B': {string.Join(", ", letras)}");

letras.Clear();  // Elimina todos los elementos de la lista
Console.WriteLine($"Después de limpiar la lista de letras: {string.Join(", ", letras)}");


// ORDENAR UNA LISTA

List<int> enteros = new List<int> { 43, 72, 32, 22, 65 };
Console.WriteLine("Lista de enteros antes de ordenar:");
Console.WriteLine(string.Join(", ", enteros));

enteros.Sort();  // Ordena la lista en orden ascendente
Console.WriteLine("Lista de números después de ordenar:");
Console.WriteLine(string.Join(", ", enteros));


// INVERTIR UNA LISTA

List<string> animales = new List<string> { "Perro", "Gato", "Pájaro", "Pez" };
Console.WriteLine("Lista de animales antes de invertir:");
Console.WriteLine(string.Join(", ", animales));

animales.Reverse();  // Invierte el orden de los elementos en la lista
Console.WriteLine("Lista de animales después de invertir:");
Console.WriteLine(string.Join(", ", animales));


// SUBLISTAS

List<int> listaEnteros = new List<int> { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
List<int> subLista = listaEnteros.GetRange(2, 5); // Obtiene una sublista que comienza en el índice 2 y tiene 5 elementos
Console.WriteLine("Sublista:");
Console.WriteLine(string.Join(", ", subLista));


// LISTAS VACÍAS

List<int> listaVacia = new List<int>();
Console.WriteLine($"La lista vacía tiene {listaVacia.Count} elementos.");


// LISTAS MULTIDIMENSIONALES

List<List<string>> matriz = new List<List<string>>
{
    new List<string> { "a", "b", "c" },
    new List<string> { "d", "e", "f" },
    new List<string> { "g", "h", "i" }
};
Console.WriteLine("Elemento en la posición (1,2) de la matriz:");
Console.WriteLine(matriz[1][2]);  // Devuelve "f"


// LISTAS VACÍAS MULTIDIMENSIONALES

List<List<string>> listaVaciaMultidimensional = new List<List<string>>();
listaVaciaMultidimensional.Add(new List<string>());
listaVaciaMultidimensional.Add(new List<string>());
Console.WriteLine($"La lista vacía multidimensional tiene {listaVaciaMultidimensional.Count} elementos.");


// SABER SI LA LISTA CONTIENE UN ELEMENTO

if (nombres.Contains("Alba"))
{
    Console.WriteLine("Alba está en la lista de nombres.");
}
else
{
    Console.WriteLine("Alba no está en la lista de nombres.");
}


// OBTENER EL MÍNIMO Y MÁXIMO DE UNA LISTA CON "MIN" Y "MAX"

List<int> numeros = new List<int> { 5, 3, 8, 2, 6 };
int minimo = numeros.Min();
int maximo = numeros.Max();
Console.WriteLine($"El número mínimo es: {minimo}");
Console.WriteLine($"El número máximo es: {maximo}");


// SUMAR LOS ELEMENTOS DE UNA LISTA CON "SUM"

List<int> listaNumeros = new List<int> { 10, 20, 30, 40, 50 };
int sumaTotal = listaNumeros.Sum();
Console.WriteLine($"La suma total de los números en la lista es: {sumaTotal}");
