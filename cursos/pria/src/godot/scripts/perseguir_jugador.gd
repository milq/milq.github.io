extends Node2D

@onready var jugador: Sprite2D = get_node("Jugador")
@onready var enemigo: Sprite2D = get_node("Enemigo")

const VELOCIDAD: int = 100

func _process(delta: float) -> void:
    # Vector desde la posición del enemigo hasta la del jugador
    var vector_hacia_jugador: Vector2 = jugador.position - enemigo.position

    # Normaliza el vector 'vector_hacia_jugador' para que su magnitud sea uno
    var normalizado: Vector2 = vector_hacia_jugador.normalized()

    # Actualiza la posición del enemigo hacia el jugador a la velocidad dada
    enemigo.position = enemigo.position + normalizado * VELOCIDAD * delta
