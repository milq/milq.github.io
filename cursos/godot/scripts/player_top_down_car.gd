extends CharacterBody2D

const ACCELERATION: float = 400.0
const FRICTION: float = 300.0
const MAX_SPEED: float = 200.0
const ROTATION_SPEED: float = 3.0

func _physics_process(delta: float) -> void:
    if Input.is_action_pressed("ui_up"):
        velocity += Vector2.UP.rotated(rotation) * ACCELERATION * delta
    elif Input.is_action_pressed("ui_down"):
        velocity += Vector2.DOWN.rotated(rotation) * ACCELERATION * delta
    else:
        if velocity.length() > 0.0:
            var friction_force: float = FRICTION * delta
            velocity = velocity.move_toward(Vector2.ZERO, friction_force)

    if Input.is_action_pressed("ui_left"):
        rotation -= ROTATION_SPEED * delta
    if Input.is_action_pressed("ui_right"):
        rotation += ROTATION_SPEED * delta

    if velocity.length() > MAX_SPEED:
        velocity = velocity.normalized() * MAX_SPEED

    move_and_slide()
