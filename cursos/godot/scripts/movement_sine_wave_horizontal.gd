extends Sprite2D

# Define el margen para reposicionar el nodo
const MARGEN: float = 32

# Define la velocidad de movimiento en píxeles por segundo
const VELOCIDAD: float = 200.0

# Posición vertical central del nodo
const Y_CENTRO: float = 300.0

# Amplitud del movimiento vertical
const Y_AMPLITUD: float = 50.0

# Multiplicador para la función seno
const MULTIPLICADOR: float = 4.0

# Tiempo transcurrido desde el inicio
var tiempo: float = 0.0

func _process(delta: float) -> void:
    # Incrementa el tiempo con el delta de cada frame
    tiempo = tiempo + delta

    # Actualiza la posición horizontal del nodo
    position.x = position.x + VELOCIDAD * delta

    # Calcula la nueva posición vertical usando una función seno
    position.y = Y_CENTRO + Y_AMPLITUD * sin(tiempo * MULTIPLICADOR)

    # Si el nodo supera el borde derecho, lo reposiciona a la izquierda
    if position.x > get_viewport_rect().size.x + MARGEN:
        position.x = -MARGEN
