extends Sprite2D

const MARGIN: float = 32
const SPEED: float = 200.0
const Y_CENTER: float = 300.0
const Y_AMPLITUDE: float = 50.0
const MULTIPLIER: float = 4.0

var time: float = 0.0

func _ready() -> void:
    pass

func _process(delta: float) -> void:
    time = time + delta
    position.x = position.x + SPEED * delta
    position.y = Y_CENTER + Y_AMPLITUDE * sin(time * MULTIPLIER)

    if position.x > get_viewport_rect().size.x + MARGIN:
        position.x = -MARGIN
