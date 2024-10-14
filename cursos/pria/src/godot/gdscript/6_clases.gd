# ------------------
# CLASES EN GDSCRIPT
# ------------------

@tool
extends EditorScript

# CLASE Punto que representa un punto en 2D
class Punto:
    # PROPIEDADES PRIVADAS
    var _x: int
    var _y: int

    # PROPIEDADES PÚBLICAS CON GETTERS Y SETTERS
    var x: int:
        get:
            return _x
        set(value):
            _x = value

    var y: int:
        get:
            return _y
        set(value):
            _y = value

    # MÉTODO CONSTRUCTOR (PÚBLICO)
    func _init(coordenada_x: int, coordenada_y: int) -> void:
        # Inicializa las propiedades '_x' e '_y'
        _x = coordenada_x
        _y = coordenada_y

    # MÉTODO PARA CALCULAR LA DISTANCIA A OTRO PUNTO (PÚBLICO)
    func distancia_a(otro: Punto) -> float:
        var dx: int = x - otro.x
        var dy: int = y - otro.y
        return sqrt(float(dx * dx + dy * dy))

# Clase Personaje
class Personaje:
    # Enumeración de estados posibles
    enum Estado { NORMAL, HERIDO, MUERTO }

    var _nombre: String
    var _x: int
    var _salud_maxima: int
    var _salud: int
    var _velocidad: int
    var _ataque: int
    var _defensa: int
    var _estado: int

    func _init(nombre: String, salud_maxima: int) -> void:
        # Inicializa las propiedades del personaje
        _nombre = nombre
        _x = 50
        _salud_maxima = salud_maxima
        _salud = salud_maxima
        _velocidad = 10
        _ataque = 8
        _defensa = 4
        _estado = Estado.NORMAL

    # Métodos de la clase
    func mover_derecha() -> void:
        # Incrementa la posición en X del personaje
        _x += _velocidad

    func recibir_daño(daño: int) -> void:
        # Reduce la salud y actualiza el estado
        _salud -= daño
        if _salud <= 0:
            _estado = Estado.MUERTO
        elif _salud < _salud_maxima / 2:
            _estado = Estado.HERIDO
        else:
            _estado = Estado.NORMAL

# Clase Animal (clase base)
class Animal:
    var _nombre: String
    var _energia: int

    func _init(nombre: String, energia: int) -> void:
        # Inicializa '_nombre' y '_energia'
        _nombre = nombre
        _energia = energia

    func set_energia(value: int) -> void:
        # Establece la energía
        _energia = value

    func comer() -> void:
        # Incrementa la energía del animal
        set_energia(_energia + 5)

    func mover() -> void:
        # Decrementa la energía del animal
        set_energia(_energia - 5)

# Clase Perro (hereda de Animal)
class Perro extends Animal:
    var _sonido: String
    var _raza: String

    func _init(nombre: String, energia: int, sonido: String,
               raza: String) -> void:
        # Llama al constructor de la clase padre 'Animal'
        super(nombre, energia)
        _sonido = sonido
        _raza = raza

    # Sobrescribe el método 'mover'
    func mover() -> void:
        # El perro gasta más energía al moverse
        set_energia(_energia - 10)

# Clase Gato (hereda de Animal)
class Gato extends Animal:
    var _sonido: String

    func _init(nombre: String, energia: int) -> void:
        # Llama al constructor de la clase padre 'Animal'
        super(nombre, energia)
        _sonido = "¡Miau!"

    func ronronear() -> void:
        # Cambia el sonido del gato a 'Prrrr...'
        _sonido = "Prrrr..."

func _run() -> void:
    # Ejemplo con la clase Punto
    var punto = Punto.new(2, 3)
    var a: int = punto.x
    var b: int = punto.y
    print("Punto X: %d, Punto Y: %d" % [a, b])

    punto.x = 5
    punto.y = -4
    print("Nuevo Punto X: %d, Punto Y: %d" % [punto.x, punto.y])

    # Calcula la distancia entre dos puntos
    var otro_punto = Punto.new(10, 10)
    var distancia = punto.distancia_a(otro_punto)
    print("Distancia entre puntos: %f" % distancia)

    # Ejemplo con la clase Personaje
    var heroe = Personaje.new("Reinwald", 50)
    var villano = Personaje.new("Zarosh", 40)

    heroe.mover_derecha()
    print("Posición en X de %s: %d" % [heroe._nombre, heroe._x])

    villano.recibir_daño(heroe._ataque)
    print("Vida de %s: %d" % [villano._nombre, villano._salud])

    # Ejemplo con la clase Animal y sus subclases
    var ruperta = Gato.new("Ruperta", 100)
    var chloe = Gato.new("Chloe", 75)

    print("Energía de %s: %d, sonido: %s" %
          [ruperta._nombre, ruperta._energia, ruperta._sonido])
    print("Energía de %s: %d, sonido: %s" %
          [chloe._nombre, chloe._energia, chloe._sonido])

    chloe.mover()
    chloe.comer()
    chloe.mover()

    ruperta.ronronear()

    print("Ahora, energía de %s es %d" % [chloe._nombre, chloe._energia])
    print("Ahora, sonido de %s es %s" % [ruperta._nombre, ruperta._sonido])

    var toby = Perro.new("Toby", 50, "¡Woof!", "Golden Retriever")
    var akira = Perro.new("Akira", 125, "¡Woof, woof!", "Siberian Husky")

    print("%s es un %s y su sonido es %s" %
          [toby._nombre, toby._raza, toby._sonido])
    print("%s es un %s y su sonido es %s" %
          [akira._nombre, akira._raza, akira._sonido])
