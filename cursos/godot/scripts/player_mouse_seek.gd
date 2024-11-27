extends CharacterBody2D

const SPEED: float = 15.0  # Celeridad máxima del movimiento
const ORIENTACIÓN_INICIAL: float = deg_to_rad(90)  # Orie. inicial del 'sprite'
const SLOWDOWN_DISTANCE: float = 50.0  # Distancia para reducir velocidad
const DISTANCIA_LLEGADA: float = 25.0  # Dis. para considerar que se ha llegado

var target_position: Vector2 # Definimos la posición objetivo

func _ready() -> void:
    # Inicializamos la posición objetivo y la posición global
    target_position = position
    global_position = position

func _process(delta: float) -> void:
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

    # Ajustamos la rotación del objeto para que mire en la dirección adecuada
    rotation = velocity.angle() + ORIENTACIÓN_INICIAL

func _input(event):
    if (event is InputEventMouseButton
            and event.button_index == MOUSE_BUTTON_RIGHT
            and event.pressed):
        # Al hacer clic derecho, se establece la posición objetivo
        target_position = get_global_mouse_position()
