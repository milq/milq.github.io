extends Sprite2D

# Constante que define la velocidad de interpolación.
# Un valor de 0.01 significa que en cada fotograma, la posición
# del nodo se acercará un 1 % a la posición final
const VELOCIDAD_INTERPOLACION: float = 0.01

# Posición inicial del nodo en pantalla
var posicion_inicial: Vector2 = Vector2(200, 200)

# Posición final del nodo en pantalla
var posicion_final: Vector2 = Vector2(900, 500)

func _ready() -> void:
    # Establece la posición inicial cuando el nodo está listo
    position = posicion_inicial

func _process(delta: float) -> void:
    # Interpolación lineal entre la posición actual y la posición final.
    position = lerp(position, posicion_final, VELOCIDAD_INTERPOLACION)

    # Detiene la interpolación cuando el nodo está cerca de la posición final
    if position.distance_to(posicion_final) < 1.0:
        position = posicion_final
