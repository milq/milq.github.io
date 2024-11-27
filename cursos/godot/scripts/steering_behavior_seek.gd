extends Node2D

# Definimos la celeridad a la que este nodo seguirá al objetivo (el ratón)
const SPEED: float = 15.0

# Distancia a partir de la cual el objeto comenzará a reducir su velocidad
const SLOWDOWN_DISTANCE: float = 50.0

# Distancia para considerar que se ha llegado al objetivo y debe de parar
const DISTANCIA_LLEGADA: float = 25.0

# Inicializamos la velocidad actual como un vector cero.
var velocity: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
    # Obtenemos la posición objetivo basada en la posición del ratón.
    var target_position: Vector2 = get_global_mouse_position()

    # Calculamos el vector hacia el objetivo ('target_position')
    var vector_to_target: Vector2 = target_position - global_position

    # Si la distancia al objetivo es menor que DISTANCIA_LLEGADA, detenemos
    if vector_to_target.length() < DISTANCIA_LLEGADA:
        velocity = Vector2.ZERO
        return

    # Calculamos la velocidad deseada normalizando la distancia y
    # multiplicándola por la celeridad de seguimiento.
    var desired_velocity: Vector2 = vector_to_target.normalized() * SPEED

    # Calculamos el 'steering' como el ajuste necesario a la velocidad actual
    var steering: Vector2 = desired_velocity - velocity

    # Actualizamos la velocidad aplicando el steering y el tiempo transcurrido
    velocity += steering * delta

    # Calculamos el factor de reducción basado en la distancia al objetivo
    var slow_down_factor: float = clamp(
        vector_to_target.length() / SLOWDOWN_DISTANCE, 0.0, 1.0)

    # Aplicamos el factor de reducción a la velocidad.
    velocity *= slow_down_factor

    # Actualizamos la posición del objeto basándonos en la velocidad y en delta
    global_position += velocity
