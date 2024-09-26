# Clase Punto
class Punto:
    def __init__(self, x, y):
        # Método constructor que inicializa los atributos 'x' e 'y'
        self._x = x
        self._y = y

    # Propiedad para 'x'
    @property
    def x(self):
        """Obtiene el valor de 'x'."""
        return self._x

    @x.setter
    def x(self, valor):
        """Establece el valor de 'x'."""
        self._x = valor

    # Propiedad para 'y'
    @property
    def y(self):
        """Obtiene el valor de 'y'."""
        return self._y

    @y.setter
    def y(self, valor):
        """Establece el valor de 'y'."""
        self._y = valor


# Clase Personaje
class Personaje:
    def __init__(self, nombre, salud_maxima):
        # Método constructor que inicializa los atributos del personaje
        self._nombre = nombre
        self._x = 50
        self._salud_maxima = salud_maxima
        self._salud = salud_maxima
        self._velocidad = 10
        self._ataque = 8
        self._defensa = 4

    # Propiedades de la clase
    @property
    def nombre(self):
        return self._nombre

    @property
    def x(self):
        return self._x

    @property
    def salud_maxima(self):
        return self._salud_maxima

    @property
    def salud(self):
        return self._salud

    @property
    def velocidad(self):
        return self._velocidad

    @property
    def ataque(self):
        return self._ataque

    @property
    def defensa(self):
        return self._defensa

    # Métodos de la clase
    def mover_derecha(self):
        # Incrementa la posición en X del personaje
        self._x += self._velocidad

    def recibir_daño(self, daño):
        # Reduce la salud del personaje según el daño recibido
        self._salud -= daño


# Clase Animal (clase base)
class Animal:
    def __init__(self, nombre, energia):
        # Método constructor que inicializa 'nombre' y 'energia'
        self._nombre = nombre
        self._energia = energia

    @property
    def nombre(self):
        return self._nombre

    @property
    def energia(self):
        return self._energia

    def comer(self):
        # Incrementa la energía del animal
        self._energia += 5

    def mover(self):
        # Decrementa la energía del animal
        self._energia -= 5


# Clase Perro (hereda de Animal)
class Perro(Animal):
    def __init__(self, nombre, energia, sonido, raza):
        # Llama al constructor de la clase padre 'Animal' usando 'super()'
        super().__init__(nombre, energia)
        self._sonido = sonido
        self._raza = raza

    @property
    def sonido(self):
        return self._sonido

    @property
    def raza(self):
        return self._raza


# Clase Gato (hereda de Animal)
class Gato(Animal):
    def __init__(self, nombre, energia):
        # Llama al constructor de la clase padre 'Animal' usando 'super()'
        super().__init__(nombre, energia)
        self._sonido = "¡Miau!"

    @property
    def sonido(self):
        return self._sonido

    def ronronear(self):
        # Cambia el sonido del gato a 'Prrrr...'
        self._sonido = "Prrrr..."


# Función principal
def main():
    # Ejemplo con la clase Punto
    punto = Punto(2, 3)
    a = punto.x  # Obtiene el valor de 'x' usando la propiedad
    b = punto.y  # Obtiene el valor de 'y' usando la propiedad
    print(f"Punto X: {a}, Punto Y: {b}")

    punto.x = 5  # Establece un nuevo valor para 'x'
    punto.y = -4  # Establece un nuevo valor para 'y'
    print(f"Nuevo Punto X: {punto.x}, Punto Y: {punto.y}")

    # Ejemplo con la clase Personaje
    heroe = Personaje("Reinwald", 50)
    villano = Personaje("Zarosh", 40)

    heroe.mover_derecha()  # El héroe se mueve hacia la derecha
    print(f"La posición en X del héroe {heroe.nombre} es {heroe.x}.")

    villano.recibir_daño(heroe.ataque)  # El villano recibe daño del héroe
    print(f"Los puntos de vida de {villano.nombre} son {villano.salud}.")

    # Ejemplo con la clase Animal y sus subclases
    ruperta = Gato("Ruperta", 100)
    chloe = Gato("Chloe", 75)

    print(f"La energía de {ruperta.nombre} es {ruperta.energia} y su sonido es {ruperta.sonido}")
    print(f"La energía de {chloe.nombre} es {chloe.energia} y su sonido es {chloe.sonido}")

    chloe.mover()  # Chloe se mueve, pierde energía
    chloe.comer()  # Chloe come, gana energía
    chloe.mover()  # Chloe se mueve nuevamente

    ruperta.ronronear()  # Ruperta cambia su sonido a 'Prrrr...'

    print(f"Ahora, la energía de {chloe.nombre} es {chloe.energia}")
    print(f"Ahora, el sonido de {ruperta.nombre} es {ruperta.sonido}")

    toby = Perro("Toby", 50, "¡Woof!", "Golden Retriever")
    akira = Perro("Akira", 125, "¡Woof, woof!", "Siberian Husky")

    print(f"{toby.nombre} es un {toby.raza} y su sonido es {toby.sonido}")
    print(f"{akira.nombre} es un {akira.raza} y su sonido es {akira.sonido}")


if __name__ == "__main__":
    main()
