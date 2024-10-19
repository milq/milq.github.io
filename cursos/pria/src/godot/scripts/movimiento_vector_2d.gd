extends Sprite2D

# Constante que define la velocidad de este nodo
const SPEED: float = 200.0

# Vector 2D que define la dirección inicial del movimiento
var direccion: Vector2 = Vector2(100, 0)

# Función que se llama en cada fotograma
# Delta es el tiempo transcurrido entre el fotograma actual y el anterior
func _process(delta: float) -> void:

    # Normalizamos la dirección para que su magnitud sea uno
    var direccion_normalizada: Vector2 = direccion.normalized()

    # Vector que será el desplazamiento a aplicar en el nodo
    var movimiento: Vector2 = direccion_normalizada * SPEED * delta

    # Actualizamos el vector de posición del nodo sumando el movimiento
    position = position + movimiento
