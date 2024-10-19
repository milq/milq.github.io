extends Node2D

@onready var jugador: Sprite2D = get_node("Jugador")
@onready var enemigo: Sprite2D = get_node("Enemigo")

const VELOCIDAD: int = 100

func _process(delta: float) -> void:
    var direccion: Vector2 = jugador.position - enemigo.position

    var dir_normalizada: Vector2 = direccion.normalized()

    enemigo.position = enemigo.position + dir_normalizada * VELOCIDAD * delta
