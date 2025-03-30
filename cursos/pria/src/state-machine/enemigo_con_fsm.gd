extends CharacterBody3D

# Enum que representa los diferentes estados posibles del enemigo
enum EnemyState { PATROL, ATTACK, GUARD }

# Exporta variables ajustables desde el editor
@export var patrol_points: Array[Marker3D]  # Puntos de patrulla
@export var target: CharacterBody3D         # Objetivo (jugador)
@export var guard: Marker3D                 # Posición de guardia
@export var attack_radius: float = 2.0      # Radio de ataque directo
@export var attack_range: float = 4.0       # Rango de detección de objetivo
@export var guard_range: float = 5.0        # Rango para volver a guardia
@export var speed: float = 3.0              # Velocidad de movimiento

# Nodo de navegación para mover al personaje por el mundo
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

# Estado actual del enemigo
var current_state: EnemyState = EnemyState.PATROL

# Índice actual del punto de patrulla
var patrol_point_index: int = 0

func _ready() -> void:
    # Inicializa el agente de navegación con una llamada diferida
    _actor_setup.call_deferred()

func _physics_process(_delta: float) -> void:
    # Ejecuta el comportamiento basado en el estado actual
    match current_state:
        EnemyState.PATROL:
            _patrol()
        EnemyState.ATTACK:
            _attack()
        EnemyState.GUARD:
            _guard()

    # Movimiento hacia el siguiente punto del camino si hay uno definido
    if not navigation_agent.is_navigation_finished():
        var direction: Vector3 = global_position.direction_to(
            navigation_agent.get_next_path_position())
        velocity = direction * speed
        move_and_slide()

func _actor_setup() -> void:
    # Espera al primer frame de física para asegurarse de que todo esté cargado
    await get_tree().physics_frame

func _set_movement_target(movement_target: Vector3) -> void:
    # Establece la posición objetivo para el agente de navegación
    navigation_agent.set_target_position(movement_target)



# ================ Estados ============================ #

# ESTADO: PATRULLA
func _patrol() -> void:
    print("Estado: Patrulla.")

    # LÓGICA DE ESTADO

    # Si llegó al destino, ir al siguiente punto de patrulla
    if navigation_agent.is_navigation_finished():
        _go_to_next_patrol_point()

    # TRANSICIONES A OTROS ESTADOS

    # Transición 1: Si ve al objetivo, cambiar a estado Ataque
    if _can_see_target():
        current_state = EnemyState.ATTACK


# ESTADO: ATAQUE
func _attack() -> void:
    print("Estado: Ataque.")

    # LÓGICA DE ESTADO

    _set_movement_target(target.global_position)   # Moverse hacia el objetivo
    # Si está suficientemente cerca, ejecutar acción de ataque
    if global_position.distance_to(target.global_position) < attack_radius:
        _attack_action()

    # TRANSICIONES A OTROS ESTADOS

    # Transición 1: Si el objetivo está lejos, cambiar a estado Guardia
    if global_position.distance_to(target.global_position) > guard_range:
        current_state = EnemyState.GUARD


# ESTADO: GUARDIA
func _guard() -> void:
    print("Estado: Guardia.")

    # LÓGICA DE ESTADO

    _set_movement_target(guard.global_position) # Ir a la posición de guardia

    # TRANSICIONES A OTROS ESTADOS

    # Transición 1: Si ve al objetivo, cambiar a estado Ataque
    if _can_see_target():
        current_state = EnemyState.ATTACK



# ================ Métodos Auxiliares ================= #

func _go_to_next_patrol_point() -> void:
    # Salir si no hay puntos de patrulla definidos
    if patrol_points.is_empty():
        return

    # Establece el siguiente punto de patrulla como destino
    var point = patrol_points[patrol_point_index]
    _set_movement_target(point.global_position)

    # Avanza al siguiente punto cíclicamente
    patrol_point_index = (patrol_point_index + 1) % patrol_points.size()

func _can_see_target() -> bool:
    # Devuelve true si el objetivo está dentro del rango de visión
    return global_position.distance_to(target.global_position) < attack_range

func _attack_action() -> void:
    print("¡Disparo!")
    # Aquí iría el código para causar daño al objetivo
