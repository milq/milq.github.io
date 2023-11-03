///////////////
// FUNCIONES //
///////////////

void Saludar()
{
    Console.WriteLine("¡Hola, mundo!\n");
}

int Cuadrado(int numero)
{
    return numero * numero;
}

int Suma(int a, int b)
{
    return a + b;
}

int Producto(int a, int b, int c)
{
    return a * b * c;
}

List<object> MediaCuadradoOrden(List<float> numeros, int n, List<string> cadenas)
{
    float media = numeros.Average();
    int cuadrado = Cuadrado(n);

    List<string> cadenasOrdenadas = new List<string>(cadenas);
    cadenasOrdenadas.Sort();

    return new List<object> { media, cuadrado, cadenasOrdenadas };
}

int Factorial(int numero)
{
    if (numero <= 1)
        return 1;
    return numero * Factorial(numero - 1);
}


//////////////
// PROGRAMA //
//////////////

Saludar();

int x = 2;
int cuadrado = Cuadrado(x);
Console.WriteLine("El cuadrado de " + x + " es " + cuadrado + ".\n");

int suma = Suma(Cuadrado(2), 3);
Console.WriteLine("La suma de " + Cuadrado(2) + " y " + 3 + " es " + suma + ".\n");

int producto = Producto(4, Suma(2, Cuadrado(1)), 2);
Console.WriteLine("El producto de 4, la suma de 2 y el cuadrado de 1, y 2 es " + producto + ".\n");

List<float> latitudes = new List<float> {-2.4f, 7.4f, 3f, 4.6f, -5f};
int numero = Suma(1, 1);
List<string> clima = new List<string> {"soleado", "nublado", "ventoso", "lluvioso"};
List<object> resultado = MediaCuadradoOrden(latitudes, numero, clima);
Console.WriteLine("Resultado de la función 'MediaCuadradoOrden':");
Console.WriteLine("Media de las latitudes: " + resultado[0]);
Console.WriteLine("Cuadrado del número: " + resultado[1]);
Console.WriteLine("Climas ordenados: " + String.Join(", ", (List<string>)resultado[2]) + "\n");
Console.WriteLine("El factorial de " + resultado[1] + " es " + Factorial((int)resultado[1]) + ".");
