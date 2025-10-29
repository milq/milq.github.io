extends Node2D

@onready var niblo: Sprite2D = get_node("Niblo")
@onready var mubbit: Sprite2D = get_node("Mubbit")

const VELOCIDAD: int = 100

func _process(delta: float) -> void:
    # Vector desde la posición de Mubbit hasta la de Niblo
    var vector_hacia_niblo: Vector2 = niblo.position - mubbit.position

    # Normaliza el vector 'vector_hacia_niblo' para que su magnitud sea uno
    var normalizado: Vector2 = vector_hacia_niblo.normalized()

    # Actualiza la posición de Mubbit hacia Niblo a la velocidad dada
    mubbit.position = mubbit.position + normalizado * VELOCIDAD * delta
