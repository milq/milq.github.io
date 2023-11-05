using System;
using System.IO;  // Para trabajar con archivos
using System.Collections.Generic;  // Para trabajar con colecciones de datos
using System.Linq;  // Para realizar operaciones de consulta

class Program
{
    static void Main()
    {
        /////////////////////////////////////////
        // EJEMPLOS DE USAR LIBRERÍAS INTERNAS //
        /////////////////////////////////////////

        // MATEMÁTICAS (FUNCIONES INCORPORADAS)

        float x = 5.0f;
        float y = 2.0f;

        float z = MathF.PI;              // Constante π                              Resultado: 3.141592...
        z = MathF.E;                     // Constante e (Número de Euler)            Resultado: 2.718281...

        z = MathF.Pow(x, y);             // Devuelve x elevado a la potencia de y
        z = MathF.Exp(x);                // Devuelve la función exponencial de un número
        z = MathF.Log(x);                // Devuelve el logaritmo natural de un número

        z = MathF.Abs(x);                // Devuelve el valor absoluto de un número

        z = MathF.Round(x);              // Devuelve el valor de un número redondeado al entero más cercano
        z = MathF.Floor(x);              // Devuelve el entero más grande menor o igual a un número
        z = MathF.Ceiling(x);            // Devuelve el entero más pequeño mayor o igual a un número

        z = MathF.Sin(x);                // Devuelve el seno de un ángulo (ángulo en radianes)
        z = MathF.Cos(x);                // Devuelve el coseno de un ángulo (ángulo en radianes)
        z = MathF.Tan(x);                // Devuelve la tangente de un ángulo (ángulo en radianes)
        z = MathF.Atan(x);               // Devuelve el arcotangente de un número, en radianes
        z = MathF.Atan2(y, x);           // Devuelve el arcotangente del cociente de sus argumentos (y sobre x), en radianes

        z = MathF.Max(x, y);             // Devuelve el mayor de dos números
        z = MathF.Min(x, y);             // Devuelve el menor de dos números

        // ALEATORIEDAD (FUNCIONES INCORPORADAS)

        // Obteniendo un número flotante aleatorio entre 0 y 1
        Random aleatorio = new Random();
        float numeroAleatorio = (float)aleatorio.NextDouble(); // Ejemplo resultado: 0.64816...

        // Obteniendo un número entero aleatorio entre dos valores, inclusivo (ejemplo: entre -3 y 10, inclusivo)
        int min = -3;
        int max = 10;
        int enteroAleatorio = aleatorio.Next(min, max + 1); // El límite superior es exclusivo, por eso agregamos 1

        // COLECCIONES (USANDO System.Collections.Generic)

        // Lista de números de punto flotante
        List<float> listaDeFlotantes = new List<float> { 1.5f, 2.3f, 3.7f, 4.2f, 5.9f };

        // Añadir elementos a la lista
        listaDeFlotantes.Add(6.1f);
        listaDeFlotantes.AddRange(new float[] { 7.4f, 8.6f, 9.0f, 10.3f });

        // Diccionario con claves de tipo string y valores de tipo float
        Dictionary<string, float> diccionarioDePrecios = new Dictionary<string, float>();
        diccionarioDePrecios.Add("Manzana", 0.75f);
        diccionarioDePrecios.Add("Pan", 1.50f);
        diccionarioDePrecios["Leche"] = 2.99f; // Otra forma de añadir elementos al diccionario

        // LINQ (USANDO System.Linq)

        // Filtrar elementos: obtener todos los números mayores que 5
        IEnumerable<float> mayoresQueCinco = listaDeFlotantes.Where(numero => numero > 5f);

        // Ordenar la lista de manera ascendente
        IOrderedEnumerable<float> listaOrdenada = listaDeFlotantes.OrderBy(numero => numero);

        // ESCRIBIR Y LEER ARCHIVOS DE TEXTO (USANDO System.IO)

        string nombreArchivo = "texto.txt";
        string texto = "¡Hola, mundo!" + Environment.NewLine + "¡Esta es otra línea de texto!";

        // Escribir texto en un archivo nuevo o sobrescribir si existe
        File.WriteAllText(nombreArchivo, texto);

        // Leer todo el texto del archivo
        string contenido = File.ReadAllText(nombreArchivo);

        /////////////////////////////////
        // SALIDA DE DATOS EN PANTALLA //
        /////////////////////////////////

        // Mostrar en consola los números en la lista de flotantes
        Console.WriteLine("Números en la lista de flotantes:");
        foreach (float numero in listaDeFlotantes)
        {
            Console.WriteLine(numero);
        }

        // Mostrar números mayores que cinco
        Console.WriteLine("\nNúmeros mayores que cinco:");
        foreach (float numero in mayoresQueCinco)
        {
            Console.WriteLine(numero);
        }

        // Mostrar precios en el diccionario
        Console.WriteLine("\nPrecios en el diccionario:");
        foreach (KeyValuePair<string, float> par in diccionarioDePrecios)
        {
            Console.WriteLine($"Producto: {par.Key}, Precio: {par.Value}");
        }

        // Mostrar el contenido leído del archivo de texto
        Console.WriteLine("\nContenido del archivo de texto:");
        Console.WriteLine(contenido);
    }
}
