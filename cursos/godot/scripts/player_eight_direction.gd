extends Sprite2D

# Constante que define la velocidad de movimiento en píxeles por segundo
const SPEED: float = 150.0

# Función que se ejecuta en cada fotograma del juego
# Delta representa el tiempo transcurrido desde el último fotograma
func _process(delta: float) -> void:

    # Obtiene el valor del eje horizontal basado en "ui_left" y "ui_right"
    # El valor resultante estará entre -1 (izquierda) y 1 (derecha)
    var horizontal: float = Input.get_axis("ui_left", "ui_right")

    # Obtiene el valor del eje vertical basado en "ui_up" y "ui_down"
    # El valor resultante estará entre -1 (arriba) y 1 (abajo).
    var vertical: float = Input.get_axis("ui_up", "ui_down")

    # Crea un vector de dirección a partir de los valores horizontales y
    # verticales. Se normaliza el vector para que la dirección tenga una
    # magnitud de uno, evitando que el movimiento sea más rápido en diagonales
    var direction: Vector2 = Vector2(horizontal, vertical).normalized()

    # Actualiza la posición del nodo sumando el vector de desplazamiento.
    # El desplazamiento se calcula multiplicando la dirección, la velocidad
    # y el tiempo delta para asegurar un movimiento suave y consistente
    position = position + direction * SPEED * delta
