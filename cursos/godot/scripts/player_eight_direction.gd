extends Sprite2D

const SPEED: float = 150.0

func _ready() -> void:
    pass

func _process(delta: float) -> void:
    var horizontal: float = Input.get_axis("ui_left", "ui_right")
    var vertical: float = Input.get_axis("ui_up", "ui_down")

    var direction: Vector2 = Vector2(horizontal, vertical).normalized()

    position = position + direction * SPEED * delta
