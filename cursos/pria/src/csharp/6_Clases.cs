using System;
using Clase;

namespace Clase
{
    public class Punto
    {
        private int x;
        private int y;

        public Punto(int x, int y)
        {
            this.x = x;
            this.y = y;
        }

        public int GetX()
        {
            return x;
        }

        public void SetX(int x)
        {
            this.x = x;
        }

        public int GetY()
        {
            return y;
        }

        public void SetY(int y)
        {
            this.y = y;
        }
    }


    public class Personaje
    {
        public string Nombre { get; private set; }
        public int X { get; private set; } = 50;
        public int SaludMaxima { get; private set; }
        public int Salud { get; private set; }
        public int Velocidad { get; } = 10;
        public int Ataque { get; } = 8;
        public int Defensa { get; } = 4;

        public Personaje(string nombre, int saludMaxima)
        {
            Nombre = nombre;
            SaludMaxima = saludMaxima;
            Salud = saludMaxima;
        }

        public void MoverDerecha()
        {
            X += Velocidad;
        }

        public void RecibirDaño(int daño)
        {
            Salud -= daño;
        }
    }

    public abstract class Animal
    {
        public string Nombre { get; protected set; }
        public int Energia { get; protected set; }

        protected Animal(string nombre, int energia)
        {
            Nombre = nombre;
            Energia = energia;
        }

        public void Comer()
        {
            Energia += 5;
        }

        public void Mover()
        {
            Energia -= 5;
        }
    }

    public class Perro : Animal
    {
        public string Sonido { get; private set; }
        public string Raza { get; private set; }

        public Perro(string nombre, int energia, string sonido, string raza)
            : base(nombre, energia)
        {
            Sonido = sonido;
            Raza = raza;
        }
    }

    public class Gato : Animal
    {
        private string sonido = "¡Miau!";

        // Propiedad de solo lectura que devuelve el valor del campo 'sonido'.
        public string Sonido => sonido;

        public Gato(string nombre, int energia) : base(nombre, energia)
        {
        }

        public void Ronronear()
        {
            sonido = "Prrrr...";
        }
    }
}

// El uso de 'using Clase;' nos ahorra tener que escribir Clase.Punto, Clase.Personaje, etc.
class Program
{
    static void Main()
    {
        // Ejemplo con la clase Punto.
        Punto punto = new Punto(2, 3);
        Clase.Punto punto2 = new Clase.Punto(2, 3);
        int a = punto.GetX();
        int b = punto.GetY();
        Console.WriteLine($"Punto X: {a}, Punto Y: {b}");

        punto.SetX(5);
        punto.SetY(-4);
        Console.WriteLine($"Nuevo Punto X: {punto.GetX()}, Punto Y: {punto.GetY()}");

        // Ejemplo con la clase Personaje.
        Personaje heroe = new Personaje("Reinwald", 50);
        Personaje villano = new Personaje("Zarosh", 40);

        heroe.MoverDerecha();
        Console.WriteLine($"La posición en X del héroe {heroe.Nombre} es {heroe.X}.");

        villano.RecibirDaño(heroe.Ataque);
        Console.WriteLine($"Los puntos de vida de {villano.Nombre} son {villano.Salud}.");

        // Ejemplo con la clase Animal y las subclases Perro y Gato.
        Gato ruperta = new Gato("Ruperta", 100);
        Gato chloe = new Gato("Chloe", 75);

        Console.WriteLine($"La energía de {ruperta.Nombre} es {ruperta.Energia} y su sonido es {ruperta.Sonido}");
        Console.WriteLine($"La energía de {chloe.Nombre} es {chloe.Energia} y su sonido es {chloe.Sonido}");

        chloe.Mover();
        chloe.Comer();
        chloe.Mover();

        ruperta.Ronronear();

        Console.WriteLine($"Ahora, la energía de {chloe.Nombre} es {chloe.Energia}");
        Console.WriteLine($"Ahora, el sonido de {ruperta.Nombre} es {ruperta.Sonido}");

        Perro toby = new Perro("Toby", 50, "¡Woof!", "Golden Retriever");
        Perro akira = new Perro("Akira", 125, "¡Woof, woof!", "Siberian Husky");

        Console.WriteLine($"{toby.Nombre} es un {toby.Raza} y su sonido es {toby.Sonido}");
        Console.WriteLine($"{akira.Nombre} es un {akira.Raza} y su sonido es {akira.Sonido}");
    }
}
