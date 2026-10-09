# ------------------
# CLASES EN GDSCRIPT
# ------------------

@tool
extends EditorScript

# Este 'script' también es una clase: hereda de EditorScript, y Godot crea
# una instancia suya y llama a su método _run() al ejecutarlo.

# CLASE Punto que representa un punto en 2D
class Punto:
    # PROPIEDADES PRIVADAS (por convención, empiezan por guion bajo)
    var _x: int
    var _y: int

    # PROPIEDADES PÚBLICAS CON GETTERS Y SETTERS
    var x: int:
        get:
            return _x
        set(valor):
            _x = valor

    var y: int:
        get:
            return _y
        set(valor):
            _y = valor

    # MÉTODO CONSTRUCTOR (PÚBLICO): new() lo llama al crear cada instancia
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
    # Enumeración de estados posibles: constantes con nombre (0, 1 y 2)
    enum Estado { NORMAL, HERIDO, MUERTO }

    var _nombre: String
    var _x: int
    var _salud_maxima: int
    var _velocidad: int
    var _ataque: int
    var _defensa: int
    var _estado: Estado = Estado.NORMAL

    # Propiedad con un 'setter' que limita su valor entre 0 y la salud
    # máxima con clampi(). Dentro de su propio 'setter', 'salud = ...' guarda
    # el valor sin volver a llamarlo
    var salud: int:
        set(valor):
            salud = clampi(valor, 0, _salud_maxima)

    # Propiedad calculada: no guarda nada; su 'getter' la calcula al leerla
    var esta_vivo: bool:
        get:
            return _estado != Estado.MUERTO

    func _init(nombre: String, salud_maxima: int) -> void:
        # Inicializa las propiedades del personaje
        _nombre = nombre
        _x = 50
        _salud_maxima = salud_maxima
        salud = salud_maxima
        _velocidad = 10
        _ataque = 8
        _defensa = 4

    # Métodos de la clase
    func mover_derecha() -> void:
        # Incrementa la posición en X del personaje
        _x += _velocidad

    func recibir_daño(daño: int) -> void:
        # Reduce la salud, pasando por su 'setter', y actualiza el estado
        salud -= daño
        if salud == 0:
            _estado = Estado.MUERTO
        elif salud * 2 < _salud_maxima:  # Menos de la mitad
            _estado = Estado.HERIDO
        else:
            _estado = Estado.NORMAL

# Clase Animal (clase base o clase padre)
class Animal:
    var _nombre: String
    var _energia: int

    func _init(nombre: String, energia: int) -> void:
        # Inicializa '_nombre' y '_energia'
        _nombre = nombre
        _energia = energia

    func set_energia(valor: int) -> void:
        # Establece la energía
        _energia = valor

    func comer() -> void:
        # Incrementa la energía del animal
        set_energia(_energia + 5)

    func mover() -> void:
        # Decrementa la energía del animal
        set_energia(_energia - 5)

# Clase Perro (hereda de Animal: es una clase hija)
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

    # Amplía el método 'comer': super.comer() ejecuta la versión del padre
    func comer() -> void:
        super.comer()  # Suma 5 de energía, como cualquier Animal
        print("%s mueve la cola." % _nombre)

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
    var punto := Punto.new(2, 3)
    var a: int = punto.x  # Pasa por el 'getter' de x
    var b: int = punto.y
    print("Punto X: %d, Punto Y: %d" % [a, b])

    punto.x = 5  # Pasa por el 'setter' de x
    punto.y = -4
    print("Nuevo Punto X: %d, Punto Y: %d" % [punto.x, punto.y])

    # Calcula la distancia entre dos puntos
    var otro_punto := Punto.new(10, 10)
    var distancia: float = punto.distancia_a(otro_punto)
    print("Distancia entre puntos: %f" % distancia)

    # Ejemplo con la clase Personaje
    var heroe := Personaje.new("Reinwald", 50)
    var villano := Personaje.new("Zarosh", 40)

    heroe.mover_derecha()
    print("Posición en X de %s: %d" % [heroe._nombre, heroe._x])

    villano.recibir_daño(heroe._ataque)
    print("Vida de %s: %d" % [villano._nombre, villano.salud])

    villano.recibir_daño(100)  # El 'setter' no deja que la salud baje de 0
    print("Vida de %s: %d. ¿Está vivo? %s" %
          [villano._nombre, villano.salud, villano.esta_vivo])

    # Ejemplo con la clase Animal y sus subclases
    var ruperta := Gato.new("Ruperta", 100)
    var chloe := Gato.new("Chloe", 75)

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

    var toby := Perro.new("Toby", 50, "¡Woof!", "Golden Retriever")
    var akira := Perro.new("Akira", 125, "¡Woof, woof!", "Siberian Husky")

    print("%s es un %s y su sonido es %s" %
          [toby._nombre, toby._raza, toby._sonido])
    print("%s es un %s y su sonido es %s" %
          [akira._nombre, akira._raza, akira._sonido])

    toby.comer()
    print("Ahora, energía de %s es %d" % [toby._nombre, toby._energia])

    # Una variable de tipo Animal puede guardar un Perro, porque un Perro es
    # un Animal. 'is' comprueba si un objeto es de una clase o de una hija suya
    var mascota: Animal = toby
    print("¿La mascota es un Perro? ", mascota is Perro)  # true
    print("¿La mascota es un Gato? ", mascota is Gato)  # false
    print("¿La mascota es un Animal? ", mascota is Animal)  # true

    # POLIMORFISMO: el 'array' es de Animal, pero cada elemento ejecuta la
    # versión de mover() de su clase real: los perros gastan más energía
    var animales: Array[Animal] = [ruperta, chloe, toby, akira]
    for animal: Animal in animales:
        animal.mover()
        print("%s se mueve y le queda %d de energía." %
              [animal._nombre, animal._energia])

    # LAS CLASES DE GODOT
    # Los nodos de Godot también son clases: new() crea una instancia de
    # cualquiera de ellos. Sprite2D, un nodo que muestra una imagen, hereda
    # de Node2D
    var escena := Node2D.new()
    var icono := Sprite2D.new()
    icono.texture = load("res://icon.svg")  # Carga una imagen del proyecto
    # Vector2 guarda un par de números (x, y): lo verás en el capítulo 3
    icono.position = Vector2(640, 360)
    escena.add_child(icono)  # 'icono' pasa a ser hijo de 'escena'
    print("Hijos de la escena: ", escena.get_child_count())  # 1
    print("¿El icono es un Node2D? ", icono is Node2D)  # true
    print("El icono está en x = ", icono.position.x)  # 640.0
    print("Distancia del icono a (0, 0): ",
          icono.position.distance_to(Vector2(0, 0)))  # 734.3...
    escena.free()  # Libera la escena y sus hijos: un nodo no se libera solo

# EL SCRIPT DE UNA ESCENA
# Un 'script' de editor no tiene escena, así que esto no se puede ejecutar
# aquí. El 'script' de una escena, como main.gd, también es una clase: hereda
# de un nodo, y Godot llama por su cuenta a sus métodos _ready(), una vez, al
# empezar, y _process(delta), en cada fotograma. Pruébalo en una escena con
# un Node2D como raíz y un Sprite2D hijo llamado Icono: pon este 'script' en
# la raíz, sin los '#' del principio, y pulsa F6.
#
# class_name Main extends Node2D  # class_name le da un nombre global
#
# @export var velocidad: float = 300.0  # Se puede cambiar en el Inspector
#
# func _ready() -> void:
#     $Icono.position = get_viewport_rect().size / 2  # Centro de la ventana
#
# func _process(delta: float) -> void:
#     # Las flechas dan una dirección: un Vector2 entre (-1, -1) y (1, 1)
#     var direccion: Vector2 = Input.get_vector(
#             "ui_left", "ui_right", "ui_up", "ui_down")
#     $Icono.position += direccion * velocidad * delta
#
# func _unhandled_input(event: InputEvent) -> void:  # Al pulsar una tecla
#     if event is InputEventKey and event.pressed and event.keycode == KEY_R:
#         get_tree().reload_current_scene()  # La R reinicia la escena
