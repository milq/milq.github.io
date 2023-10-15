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


// ELIMINAR UN ELEMENTO DE LA LISTA

List<string> colores = new List<string> { "Azul", "Naranja", "Verde", "Amarillo", "Blanco" };

colores.RemoveAt(0);
colores.RemoveAt(2);
colores.RemoveAt(colores.Count - 1);

Console.WriteLine(string.Join(", ", colores));


// BUSCAR UN ELEMENTO EN LA LISTA

if (nombres.Contains("Alba"))
{
    Console.WriteLine("Alba está en la lista de nombres.");
}
else
{
    Console.WriteLine("Alba no está en la lista de nombres.");
}
