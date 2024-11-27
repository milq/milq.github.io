extends Node2D

# Definimos la celeridad a la que este nodo seguirá al objetivo (el ratón)
const SPEED: float = 15.0

# Distancia a partir de la cual el objeto comenzará a reducir su velocidad.
const SLOWDOWN_DISTANCE: float = 5.0

# Inicializamos la velocidad actual como un vector cero.
var velocity: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
    # Obtenemos la posición objetivo basada en la posición del ratón.
    var target_position: Vector2 = get_global_mouse_position()

    # Calculamos el vector hacia el objetivo ('target_position')
    var to_target_vector: Vector2 = target_position - self.global_position

    # Calculamos la velocidad deseada normalizando la distancia y
    # multiplicándola por la celeridad de seguimiento.
    var desired_velocity: Vector2 = to_target_vector.normalized() * SPEED

    # Calculamos el 'steering' como el ajuste necesario a la velocidad actual
    var steering: Vector2 = desired_velocity - velocity

    # Actualizamos la velocidad aplicando el steering y el tiempo transcurrido
    velocity += steering * delta

    # Calculamos el factor de reducción basado en la distancia al objetivo
    var slow_down_factor: float = clamp(
        to_target_vector.length() / SLOWDOWN_DISTANCE, 0.0, 1.0)

    # Aplicamos el factor de reducción a la velocidad.
    velocity *= slow_down_factor

    # Actualizamos la posición del objeto basándonos en la velocidad y en delta
    global_position += velocity
