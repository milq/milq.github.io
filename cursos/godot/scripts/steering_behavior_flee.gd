extends Node2D

# Velocidad máxima de huida
const SPEED: float = 15.0

# Distancia mínima a partir de la cual se detiene
const DISTANCIA_HUIDA: float = 250.0

# Distancia en la que comienza a desacelerar
const SLOWDOWN_DISTANCE: float = 50.0

# Variables
var velocity: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
    # Obtenemos la posición objetivo basado en la posición del ratón
    var target_position: Vector2 = get_global_mouse_position()

    # Calculamos el vector hacia el objetivo (en 'flee' se invierte el vector)
    var vector_to_target: Vector2 = global_position - target_position

    # Calculamos la distancia actual al objetivo
    var distance_to_target: float = vector_to_target.length()

    # Si la distancia es mayor que DISTANCIA_HUIDA, detenemos el movimiento
    if distance_to_target > DISTANCIA_HUIDA:
        velocity = Vector2.ZERO
        return

    # Calculamos la velocidad deseada para huir.
    var desired_velocity: Vector2 = vector_to_target.normalized() * SPEED

    # Calculamos el 'steering' como el ajuste necesario a la velocidad actual
    var steering: Vector2 = desired_velocity - velocity

    # Actualizamos la velocidad aplicando el steering y el tiempo transcurrido
    velocity += steering * delta

    # Reducimos la velocidad cerca de DISTANCIA_HUIDA según SLOWDOWN_DISTANCE
    var distance_from_stop: float = DISTANCIA_HUIDA - distance_to_target
    var slow_down_factor: float = clamp(
        distance_from_stop / SLOWDOWN_DISTANCE, 0.0, 1.0)

    # Aplicamos el factor de reducción a la velocidad
    velocity *= slow_down_factor

    # Actualizamos la posición del objeto basándonos en la velocidad y en delta
    global_position += velocity
